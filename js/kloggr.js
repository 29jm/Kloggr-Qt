var kloggr;

/////////////////////////// entities.js /////////////////////////////

/*	Square base class.
 *	Used by BasicEnemy, Player and Target
 */
function Square(w, h, texture) {
	this.m_x = 0;
	this.m_y = 0;
	this.m_width = w;
	this.m_height = h;
	this.m_visible = true;
	this.texture = texture;
	this.collidable = true;

	this.object = Qt.createQmlObject(this.newQmlObject(w, h, texture), kloggr, "Square");
}

Object.defineProperty(Square.prototype, "x", {
						  get: function() { return this.m_x; },
						  set: function(val) { this.m_x = val; this.object.x = val; }
					  });

Object.defineProperty(Square.prototype, "y", {
						  get: function() { return this.m_y; },
						  set: function(val) { this.m_y = val; this.object.y = val; }
					  });

Object.defineProperty(Square.prototype, "width", {
						  get: function() { return this.m_width; },
						  set: function(val) { this.m_width = val; this.object.width = val; }
					  });

Object.defineProperty(Square.prototype, "height", {
						  get: function() { return this.m_height; },
						  set: function(val) { this.m_height = val; this.object.height = val; }
					  });

Object.defineProperty(Square.prototype, "visible", {
						  get: function() { return this.m_visible; },
						  set: function(val) { this.m_visible = val; this.object.visible = val; }
					  });

Square.prototype.newQmlObject = function(w, h, texture) {
	if (/#[0-9a-zA-Z]{6}/.test(texture)) {
		return "import QtQuick 2.3;\
				Rectangle {\
					width:"+w+";\
					height:"+h+";\
					color:\""+texture+"\";\
				}";
	}
	else {
		return "import QtQuick 2.3;\
				Image {\
					source:\""+texture+"\";\
					width:"+w+";\
					height:"+h+";\
				}";
	}
};

Square.prototype.collideBox = function(box_x, box_y, box_w, box_h) {
	if (this.x < box_x) {
		this.x = box_x;
		this.speed_x = 0;
	}
	if (this.x+this.width > box_x+box_w) {
		this.x = (box_x+box_w)-this.width;
		this.speed_x = 0;
	}
	if (this.y < box_y) {
		this.y = box_y;
		this.speed_y = 0;
	}
	if (this.y+this.height > box_y+box_h) {
		this.y = (box_y+box_h)-this.height;
		this.speed_y = 0;
	}
};

Square.prototype.respawn = function(gameobjects, max_x, max_y) {
	this.x = Math.random()*(max_x-this.width);
	this.y = Math.random()*(max_y-this.height);
};

Square.prototype.intersect = function(b, silent) {
	var a = this;
	if (silent === undefined) {
		silent = true;
	}

	if (b.x >= a.x+a.width ||
		b.x+b.width <= a.x ||
		b.y >= a.y+a.height ||
		b.y+b.height <= a.y) {
		return false;
	}

	if (!silent) {
		if (a.onCollide) {
			a.onCollide(b);
		}

		if (b.onCollide) {
			b.onCollide(a);
		}
	}

	return true;
}

/*  Enemy abstract class. Used by everything that causes damage
 *  to the player.
 */
function Enemy() {

}

Enemy.prototype = Object.create(Square.prototype);

/*	BasicEnemy class.
 *	Drawn using color-filled rectangles
 */
function BasicEnemy() {
	Square.call(this, 15, 15, '#27AE60');
	this.to_update = false;
}

BasicEnemy.prototype = Object.create(Enemy.prototype);

BasicEnemy.prototype.respawn = function(gameobjects, max_x, max_y) {
	var location_found = false;

	while (!location_found) {
		Square.prototype.respawn.
			call(this, gameobjects, max_x, max_y);
		var good_location = true;

		var len = gameobjects.length;
		for (var i = 0; i < len; i++) {
			if (gameobjects[i] instanceof Player ||
				gameobjects[i] instanceof Target) {
				if (this.intersect(gameobjects[i])) {
					good_location = false;
				}
			}
		}

		if (good_location) {
			location_found = true;
		}
	}
};

BasicEnemy.prototype.update = function(delta_t) {

};

/*	Player class.
 *	Drawn using a texture, can move, etc...
 */
function Player() {
	Square.call(this, 40, 40, '../assets/player.png');

	this.speed_x = 0;
	this.speed_y = 0;
	this.max_speed = 300;
	this.slowing_speed = 0.7;
	this.accel = 7;
	this.dead = false;
}

Player.prototype = Object.create(Square.prototype);

Player.prototype.respawn = function(gameobjects, max_x, max_y) {
	Square.prototype.respawn.
		call(this, gameobjects, max_x, max_y);
	this.speed_x = 0;
	this.speed_y = 0;
}

Player.prototype.update = function(delta_t) {
	var len = Math.sqrt((this.speed_x*this.speed_x)
						+ (this.speed_y*this.speed_y));

	if (Math.round(len) == 0) {
		this.speed_x = 0;
		this.speed_y = 0;
		return;
	}

	this.speed_x = (this.speed_x / len)*(len-this.slowing_speed);
	this.speed_y = (this.speed_y / len)*(len-this.slowing_speed);

	if (Math.abs(this.speed_x) > this.max_speed) {
		this.speed_x = (this.speed_x > 0 ?
			this.max_speed : -this.max_speed);
	}

	if (Math.abs(this.speed_y) > this.max_speed) {
		this.speed_y = (this.speed_y > 0 ?
			this.max_speed : -this.max_speed);
	}

	this.x += this.speed_x*delta_t;
	this.y += this.speed_y*delta_t;
};

Player.prototype.onCollide = function(gameobject) {
	if (gameobject instanceof Enemy) {
		this.dead = true;
		this.texture.src = '../assets/deadPlayer.png';
	}
}

/*	Target class. inherits Square.
 *	Able to move, decelerate, change of behavior...
 */
function Target() {
	Square.call(this, 40, 40, '../assets/target.png');

	this.State = {
		Fix:"Fix",
		Bouncing:"Bouncing",
		Moving:"Moving"
	};

	this.speed_x = 0;
	this.speed_y = 0;
	this.max_speed = 200;
	this.slowing_speed = 0.7;

	this.state = this.State.Fix;
	this.accumulator = 0;
}

Target.prototype = Object.create(Square.prototype);

Target.prototype.respawn = function(gameobjects, max_x, max_y) {
	var location_found = false;

	while (!location_found) {
		Square.prototype.respawn.call(this, gameobjects, max_x, max_y);

		var len = gameobjects.length;
		for (var i = 0; i < len; i++) {
			if (this.intersect(gameobjects[i])) {
				continue;
			}

			if (gameobjects[i] instanceof Player) {
				var half = ((max_x+max_y)/2)/2;

				if (this.distanceTo(gameobjects[i]) > half) {
					location_found = true;
				}
			}

			if (location_found) {
				break;
			}
		}
	}
};

Target.prototype.update = function(delta_t) {
	var len = 0;

	this.accumulator += delta_t;
	if (this.accumulator > 2 && this.state == this.State.Bouncing) {
		this.accumulator = 0;

		this.speed_x = ((Math.random()*this.max_speed*2)-this.max_speed);
		this.speed_y = ((Math.random()*this.max_speed*2)-this.max_speed);
		len = Math.sqrt((this.speed_x*this.speed_x)
						+ (this.speed_y*this.speed_y));
		this.speed_x = (this.speed_x/len)*this.max_speed;
		this.speed_y = (this.speed_y/len)*this.max_speed;
	}

	if (len == 0) { // Don't recalculate twice
		len = Math.sqrt((this.speed_x*this.speed_x)
						+ (this.speed_y*this.speed_y));
	}

	if (Math.round(len) == 0) {
		this.speed_x = 0;
		this.speed_y = 0;
		return; // No movement needed
	}

	this.speed_x = (this.speed_x / len)*(len-this.slowing_speed);
	this.speed_y = (this.speed_y / len)*(len-this.slowing_speed);

	if (Math.abs(this.speed_x) > this.max_speed) {
		this.speed_x = (this.speed_x > 0 ?
			this.max_speed : -this.max_speed);
	}

	if (Math.abs(this.speed_y) > this.max_speed) {
		this.speed_y = (this.speed_y > 0 ?
			this.max_speed : -this.max_speed);
	}

	this.x += this.speed_x*delta_t;
	this.y += this.speed_y*delta_t;
};

Target.prototype.distanceTo = function(b) {
	return Math.sqrt((this.x-b.x)*(this.x-b.x) + (this.y-b.y)*(this.y-b.y));
};

Target.prototype.updateState = function(score) {
	switch (score) {
	case 5:
		this.state = this.State.Bouncing;
		break;
	}
}

/* The Lazer class is an Enemy, but it initializes from a Square.
 * Its behavior is controlled through the State enumeration.
 */
function Lazer() {
	Square.call(this, 15, 120, "../assets/lazer.png");

	this.State = {
		Inactive:"Inactive",
		On:"On",
		Off:"Off"
	};

	this.accumulator = 0;
	this.state = this.State.On;
}

Lazer.prototype = Object.create(Enemy.prototype);

// The lazer spawns between the payer and the target
Lazer.prototype.respawn = function(gameobjects, max_x, max_y) {
	var player;
	var target;
	var len = gameobjects.length;
	for (var i = 0; i < len; i++) {
		if (gameobjects[i] instanceof Player) {
			player = gameobjects[i];
		}
		else if (gameobjects[i] instanceof Target) {
			target = gameobjects[i];
		}
	}

	if (!player || !target) {
		console.log("Lazer was spawned before player or target. FIX");
		Square.prototype.respawn.call(this, gameobjects, max_x, max_y);
		return;
	}

	if (Math.abs(player.x-target.y) < this.texture.width) {
		console.log("Not enough room for Lazer, going full retard");
		Square.prototype.respawn.call(this, gameobjects, max_x, max_y);
		return;
	}

	this.height = max_y;
	this.x = Math.abs(player.x+target.y-this.texture.width)/2;
	this.y = 0;
};

Lazer.prototype.update = function(delta_t) {
	if (this.state == this.State.Inactive) {
		return;
	}

	this.accumulator += delta_t;
	if (this.accumulator > 2.0) {
		this.accumulator = 0;
		if (this.state == this.State.On) {
			this.state = this.State.Off;
			this.draw = function(context) {};
			this.collidable = false;
		}
		else {
			this.state = this.State.On;
			this.draw = Square.prototype.drawImage;
			this.collidable = true;
		}
	}
};

Lazer.prototype.updateState = function(score) {
	switch (score) {
	case 10:
		this.state = this.State.On;
		break;
	}
}


////////////////////////// kloggr.js /////////////////////////////
function Kloggr(width, height) {
	this.width = width;
	this.height = height;

	this.restart();
	this.state = Kloggr.State.MainMenu;
}

Kloggr.State = {
	Playing:"Playing",
	Paused:"Paused",
	Dead:"Dead",
	MainMenu:"MainMenu"
};

Kloggr.Events = {
	NewHighscore:"NewHighscore",
	StateChanged:"StateChanged",
	ScoreChanged:"ScoreChanged",
	TargetReached:"TargetReached",
	TimeChanged:"TimeChanged"
};

Kloggr.prototype.restart = function() {
	// Set default values
	this.state = Kloggr.State.Playing;
	this.events = [];
	this.keys_pressed = {};
	this.touchmoves = [0, 0];
	this.score = 0;
	this.counter = 0;
	this.enemy_density = 0.005;

	// Spawn gameobjects
	this.respawnAll(true);
};

Kloggr.prototype.setKeyState = function(key, state) {
	if (state) {
		this.keys_pressed[key] = state;
	}
	else {
		delete this.keys_pressed[key];
	}
};

Kloggr.prototype.handleKeys = function() {
	if (Qt.Key_Left in this.keys_pressed) {
		this.player.speed_x -= this.player.accel;
	}

	if (Qt.Key_Right in this.keys_pressed) {
		this.player.speed_x += this.player.accel;
	}

	if (Qt.Key_Up in this.keys_pressed) {
		this.player.speed_y -= this.player.accel;
	}

	if (Qt.Key_Down in this.keys_pressed) {
		this.player.speed_y += this.player.accel;
	}
};

Kloggr.prototype.handleTouchStart = function(event) {
	var touchobj = event.changedTouches[0];
	this.touchmoves[0] = touchobj.pageX;
	this.touchmoves[1] = touchobj.pageY;

	event.preventDefault();
};

Kloggr.prototype.handleTouchMove = function(event) {
	var touchobj = event.changedTouches[0];
	var dpr = window.devicePixelRatio;
	var move_x = touchobj.pageX*dpr - this.touchmoves[0]*dpr;
	var move_y = touchobj.pageY*dpr - this.touchmoves[1]*dpr;

	// Should be done during update(), but hey, lack of funding
	this.player.speed_x += move_x;
	this.player.speed_y += move_y;

	this.touchmoves[0] = touchobj.pageX;
	this.touchmoves[1] = touchobj.pageY;
	event.preventDefault();
};

// Move objects
Kloggr.prototype.update = function(delta_t) {
	if (Math.floor(this.counter+delta_t)
			> Math.floor(this.counter)) {
		this.newEvent(Kloggr.Events.TimeChanged,
				Math.floor(this.counter+delta_t));
	}

	this.counter += delta_t;

	var len = this.gameobjects.length;
	for (var i = 0; i < len; i++) {
		if (this.gameobjects[i].to_update === false) {
			continue;
		}

		this.gameobjects[i].update(delta_t);
	}
};

Kloggr.prototype.collisionDetection = function() {
	// Wall collisions
	this.player.collideBox(0, 0, this.width, this.height);
	this.target.collideBox(0, 0, this.width, this.height);

	if (Square.prototype.intersect.call(this.player, this.target)) {
		this.score += 1;
		this.enemy_density += 0.001;

		// Kloggr.score has its own setter that calls
		// Kloggr.newEvents, so no need for it here
		this.newEvent(Kloggr.Events.TargetReached);
	}

	var len = this.gameobjects.length;
	for (var i = 0; i < len; i++) {
		if (this.gameobjects[i] instanceof Enemy) {
			if (this.gameobjects[i].collidable) {
				if (Square.prototype.intersect.call(this.player, this.gameobjects[i])) {
					this.state = Kloggr.State.Dead;
					this.newEvent(Kloggr.Events.StateChanged, this.state);
				}
			}
		}
	}
};

// Draw objects
Kloggr.prototype.draw = function(context) {
	var len = this.gameobjects.length;
	for (var i = 0; i < len; i++) {
		this.gameobjects[i].draw(context);
	}
};

/* These 2 functions are used to transmit messages
 * to the external main loop.
 */
Kloggr.prototype.newEvent = function(evt, val) {
	this.events.push({
		name:evt,
		value:val
	});
};

Kloggr.prototype.getEvents = function() {
	var tmp = this.events;
	this.events = [];

	return tmp;
};

// Return the the number of enemies to create
Kloggr.prototype.numberOfEnemies = function() {
	var enemy_ratio = this.enemy_density/100;
	var screen_area = this.width*this.height;

	return Math.round(enemy_ratio*screen_area);
};

Kloggr.prototype.respawnAll = function(full_restart) {
	if (!full_restart) {
		var player_x = this.player.x;
		var player_y = this.player.y;

		this.player.respawn(this.gameobjects, this.width, this.height);
		this.target.respawn(this.gameobjects, this.width, this.height);

		this.player.x = player_x;
		this.player.y = player_y;
	}
	else {
		this.gameobjects = [];
		this.gameobjects.push(new Player());
		this.gameobjects.push(new Target());

		this.player = this.gameobjects[0];
		this.target = this.gameobjects[1];

		this.player.respawn(this.gameobjects, this.width, this.height);
		this.target.respawn(this.gameobjects, this.width, this.height);
	}

	this.respawnEnemies();
};

Kloggr.prototype.respawnEnemies = function() {
	console.log("Spawning "+this.numberOfEnemies()+" enemies");

	var num_enemies = this.numberOfEnemies();
	var enemy_count = 0;
	for (var i = 0; i < this.gameobjects.length; i++) {
		if (this.gameobjects[i] instanceof BasicEnemy) {
			enemy_count	+= 1;
		}
	}

	if (enemy_count < num_enemies) {
		var diff = num_enemies - enemy_count;
		for (var i = 0; i < diff; i++) {
			this.gameobjects.push(new BasicEnemy());
		}
	}

	for (var i = 0; i < this.gameobjects.length; i++) {
		if (this.gameobjects[i] instanceof Enemy) {
			this.gameobjects[i].
				respawn(this.gameobjects, this.width, this.height);
		}
	}
};

// Define getters/setters to automatize things
Object.defineProperty(Kloggr.prototype, 'score', {
	get: function() {
		return this._score;
	},

	set: function(value) {
		this._score = value;
		this.newEvent(Kloggr.Events.ScoreChanged, value);

		// Allow objects to change state
		if (!this.gameobjects) {
			return;
		}

		for (var i = 0; i < this.gameobjects.length; i++) {
			if (this.gameobjects[i].updateState) {
				this.gameobjects[i].updateState(value);
			}
		}

		switch (value) {
		case 10:
			this.gameobjects.push(new Lazer());
			break;
		}
	}
});

