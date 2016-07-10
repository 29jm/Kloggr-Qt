var kloggr;
var pixelDensity;

// Math helper functions

// Returns true if the square intersects another, else false
// Also calls collision handlers (not very elegant, right)
function intersect(a, b) {
	if (b.x >= a.x+a.width  ||
		b.x+b.width <= a.x  ||
		b.y >= a.y+a.height ||
		b.y+b.height <= a.y) {
		return false;
	}

	if (a.onCollide) {
		a.onCollide(b);
	}

	if (b.onCollide) {
		b.onCollide(a);
	}

	return true;
}

// Check if two lines intersect. 4 points as input, 2 = 1 line
function lineIntersect(p1, p2, p3, p4) {
	var x = ((p1.x*p2.y-p1.y*p2.x)*(p3.x-p4.x)-(p1.x-p2.x)*(p3.x*p4.y-p3.y*p4.x))
	        / ((p1.x-p2.x)*(p3.y-p4.y)-(p1.y-p2.y)*(p3.x-p4.x));
	var y = ((p1.x*p2.y-p1.y*p2.x)*(p3.y-p4.y)-(p1.y-p2.y)*(p3.x*p4.y-p3.y*p4.x))
	        / ((p1.x-p2.x)*(p3.y-p4.y)-(p1.y-p2.y)*(p3.x-p4.x));

	if (isNaN(x) || isNaN(y)) {
		return false;
	} else {
		if (p1.x >= p2.x) {
			if (!(p2.x <= x && x <= p1.x)) return false;
		} else {
			if (!(p1.x <= x && x <= p2.x)) return false;
		}
		if (p1.y >= p2.y) {
			if (!(p2.y <= y && y <= p1.y)) return false;
		} else {
			if (!(p1.y <= y && y <= p2.y)) return false;
		}
		if (p3.x >= p4.x) {
			if (!(p4.x <= x && x <= p3.x)) return false;
		} else {
			if (!(p3.x <= x && x <= p4.x)) return false;
		}
		if (p3.y >= p4.y) {
			if (!(p4.y <= y && y <= p3.y)) return false;
		} else {
			if (!(p3.y <= y && y <= p4.y)) return false;
		}
	}

	return true;
}

// Check whether a line crosses a rectangle
function lineIntersectRectangle(p1, p2, rect) {
	if (lineIntersect(p1, p2, {x:rect.x,y:rect.y}, {x:rect.x+rect.width,y:rect.y}) ||
		lineIntersect(p1, p2, {x:rect.x+rect.width,y:rect.y}, {x:rect.x+rect.width,y:rect.y+rect.height}) ||
		lineIntersect(p1, p2, {x:rect.x+rect.width,y:rect.y+rect.height}, {x:rect.x,y:rect.y+rect.height}) ||
		lineIntersect(p1, p2, {x:rect.x,y:rect.y+rect.height}, {x:rect.x,y:rect.y}) ) {
		return true;
	}

	return false;
}

// Returns the distance between a point and another
// Beware of edge cases
function distanceBetween(a, b) {
	return Math.sqrt((a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y));
};

/////////////////////////// entities.js /////////////////////////////

// Some constants
var BASIC_ENEMY_SIZE = 2.4;
var BASIC_ENEMY_VARIATION = 0.3;
var PLAYER_SIZE = 6;
var TARGET_SIZE = 3;
var LAZER_SIZE = 2.64

/*	Square base class.
 *	Used by every game object. Drawn using a QML object
 *  The size of the square is expressed in millimeters
 */
function Square(w, h, texture) {
	this.m_x = 0;
	this.m_y = 0;
	this.m_width = w*pixelDensity;
	this.m_height = h*pixelDensity;
	this.m_visible = true;
	this.texture = texture;
	this.collidable = true;

	this.object = this.newQmlObject(this.m_width, this.m_height, texture);
}

Square.base_object = Qt.createComponent("../Square.qml");

// These things bind objects properties to the qml object's properties
// so you can do obj.x = y; and have your QML object move on the screen
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
	set: function(val) { this.m_width = val*pixelDensity; this.object.width = val; }
});

Object.defineProperty(Square.prototype, "height", {
	get: function() { return this.m_height; },
	set: function(val) { this.m_height = val*pixelDensity; this.object.height = val; }
});

Object.defineProperty(Square.prototype, "visible", {
	get: function() { return this.m_visible; },
	set: function(val) { this.m_visible = val; this.object.visible = val; }
});

Object.defineProperty(Square.prototype, "opacity", {
	get: function() { return this.m_opacity; },
	set: function(val) { this.m_opacity = val; this.object.opacity = val; }
});

Object.defineProperty(Square.prototype, "source", {
	get: function() { return this.m_source; },
	set: function(val) { this.m_source = val; this.object.source = val; }
});

// Returns a QML object. If texture is a color a Rectangle is created,
// else the texture parameter is used as a path to an asset.
Square.prototype.newQmlObject = function(w, h, texture) {
	var col;
	var src;

	if (/#[0-9a-zA-Z]{6}/.test(texture)) {
		col = texture;
	} else {
		src = texture;
	}

	return Square.base_object.createObject(kloggr, {width: w, height: h, color: col, source: src});
};

// Prevents the square from escaping a rectangle, usually the window
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

// Respawns the square randomly within 0;max_x and 0;max_y
Square.prototype.respawn = function(gameobjects, max_x, max_y) {
	this.x = Math.random()*(max_x-this.width);
	this.y = Math.random()*(max_y-this.height);
};

// Respawns the square at a minimum distance from another.
// You can supply a custom respawn function
Square.prototype.respawnFarFrom = function(gameobjects, max_x, max_y, object, distance, func) {
	while (true) {
		if (func) {
			func.call(this, gameobjects, max_x, max_y);
		} else {
			Square.prototype.respawn.call(this, gameobjects, max_x, max_y);
		}

		var this_angles = [
			{ x: this.x, y: this.y },
			{ x: this.x+this.width, y: this.y },
			{ x: this.x+this.width, y: this.y+this.height },
			{ x: this.x, y: this.y+this.height }
		];

		var object_angles = [
			{ x: object.x, y: object.y },
			{ x: object.x+object.width, y: object.y },
			{ x: object.x+object.width, y: object.y+object.height },
			{ x: object.x, y: object.y+object.height }
		];

		var good_spawn = true;
		for (var i = 0; i < this_angles.length; i++) {
			for (var j = 0; j < object_angles.length; j++) {
				if (distanceBetween(this_angles[i], object_angles[j]) < distance) {
					good_spawn = false;
				}
			}
		}

		if (good_spawn) {
			break;
		}
	}
}

Square.prototype.enable = function() {
	this.opacity = 1;
	this.collidable = true;
}

Square.prototype.disable = function() {
	this.opacity = 0;
	this.collidable = false;
}

/*  Enemy abstract class. Base class of everything that can kill the player
 */
function Enemy() {

}

Enemy.prototype = Object.create(Square.prototype);

/*	BasicEnemy, the little red square that you must not touch.
 *	Its size varies a bit.
 *	More and more appear as the player reaches more targets
 */
function BasicEnemy() {
	var width = (Math.random()*BASIC_ENEMY_VARIATION*2-BASIC_ENEMY_VARIATION)
	    + BASIC_ENEMY_SIZE;

	Square.call(this, width, width, '#f04155');
	this.to_update = false;
}

BasicEnemy.prototype = Object.create(Enemy.prototype);

// Do not respawn neither on the player nor on the target
BasicEnemy.prototype.respawn = function(gameobjects, max_x, max_y) {
	var player;
	for (var i = 0; i < gameobjects.length; i++) {
		if (gameobjects[i] instanceof Player) {
			player = gameobjects[i];
		}
	}

	do {
		this.respawnFarFrom(gameobjects, max_x, max_y, player, player.width);

	} while (intersect(this, player));
};

// They never move, they just respawn
BasicEnemy.prototype.update = function(delta_t) {

};

/*	Player class.
 *	Drawn using a texture, can move, etc...
 */
function Player() {
	Square.call(this, PLAYER_SIZE, PLAYER_SIZE, "../assets/player/player.svg");

	// Everything should be in mm/s
	this.speed_x = 0;
	this.speed_y = 0;
	this.max_speed = 90;
	this.slowing_speed = 0.21;
	this.accel = 1.5;
	this.dead = false;
}

Player.prototype = Object.create(Square.prototype);

// Kill the velocity when respawning
// When the player just reached a target, it is reset to his previous position
// but the respawn bit is needed when the game is started
Player.prototype.respawn = function(gameobjects, max_x, max_y) {
	Square.prototype.respawn.call(this, gameobjects, max_x, max_y);
	this.speed_x = 0;
	this.speed_y = 0;
	this.source = "../assets/player/player.svg";
}

// Move the player according to his velocity and the time passed.
// Ensure that it doesn't exceed speed limits and decrease his speed a bit
// every frame so it eventually stops if the player doesn't make it move
Player.prototype.update = function(delta_t) {
	var len = Math.sqrt((this.speed_x*this.speed_x)+(this.speed_y*this.speed_y));

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

	this.x += this.speed_x*pixelDensity*delta_t;
	this.y += this.speed_y*pixelDensity*delta_t;
};

Player.prototype.onCollide = function(b) {
	if (b instanceof Enemy) {
		this.source = "../assets/player/deadPlayer.svg";
	}
}

/*	Target class.
 *	Able to move, decelerate, change of behavior...
 *	There are useless states in here, just Bouncing and Fix are used
 *	Every frame a counter is increased by delta_t, and when delta_t > 2s
 *	the target bounces then decelerates.
 */
function Target() {
	Square.call(this, TARGET_SIZE, TARGET_SIZE, '#2ecc71');

	this.State = {
		Fix:"Fix",
		Bouncing:"Bouncing",
		Moving:"Moving"
	};

	this.speed_x = 0;
	this.speed_y = 0;
	this.max_speed = 60;
	this.slowing_speed = 0.21;

	this.state = this.State.Fix;
	this.accumulator = 0;
}

Target.prototype = Object.create(Square.prototype);

// Respawns far from the player (at least half the window width)
Target.prototype.respawn = function(gameobjects, max_x, max_y) {
	this.accumulator = 1.3;
	this.speed_x = 0;
	this.speed_y = 0;

	for (var i = 0; i < gameobjects.length; i++) {
		if (gameobjects[i] instanceof Player) {
			this.player = gameobjects[i];
		}
	}

	while (true) {
		this.respawnFarFrom(gameobjects, max_x, max_y, this.player, max_x/2);
		var good_spawn = true;

		for (var i = 0; i < gameobjects; i++) {
			if (gameobjects[i] instanceof Enemy) {
				if (intersect(this, gameobjects[i])) {
					good_spawn = false;
				}
			}
		}

		if (good_spawn) {
			break;
		}
	}
};

// Returns a vector which is guaranteed not to point toward object
Target.prototype.getRandomDirectionAvoiding = function(object) {
	var points = [
		{ x: this.x, y: this.y },
		{ x: this.x+this.width, y: this.y },
		{ x: this.x+this.width, y: this.y+this.height },
		{ x: this.x, y: this.y+this.height },
	]

	while (true) {
		// x10000 because the end of the line m ust be far away, i.e not stop before rect
		var vector = {
			x: ((Math.random()*this.max_speed*2)-this.max_speed)*10000,
			y: ((Math.random()*this.max_speed*2)-this.max_speed)*10000
		}

		var good_direction = true;

		for (var i = 0; i < points.length; i++) {
			var end = { x:points[i].x+vector.x,y:points[i].y+vector.y };
			if (lineIntersectRectangle(points[i], end, object)) {
				good_direction = false;
				break;
			}
		}

		if (good_direction) {
			return vector;
		}
	}
}

// Quite similar to Player.update but with the counter and bounce added
Target.prototype.update = function(delta_t) {
	var len = 0;
	this.accumulator += delta_t;

	// Every 2 seconds, bounce
	if (this.accumulator > 2 && this.state === this.State.Bouncing) {
		this.accumulator = 0;

		var vec = this.getRandomDirectionAvoiding(this.player);
		this.speed_x = vec.x;
		this.speed_y = vec.y;
		len = Math.sqrt((this.speed_x*this.speed_x)+(this.speed_y*this.speed_y));
		this.speed_x = (this.speed_x/len)*this.max_speed;
		this.speed_y = (this.speed_y/len)*this.max_speed;
	} else { // Don't move that
		len = Math.sqrt((this.speed_x*this.speed_x)+(this.speed_y*this.speed_y));
	}

	if (Math.round(len) == 0) {
		this.speed_x = 0;
		this.speed_y = 0;
		return; // No movement needed
	}

	// Reduce the length of the direction vector by slowing_speed
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

	this.x += this.speed_x*pixelDensity*delta_t;
	this.y += this.speed_y*pixelDensity*delta_t;
};

// Called whenever the score changes. It begins to bounce only at score=5
Target.prototype.updateState = function(score) {
	switch (score) {
	case 5:
		this.state = this.State.Bouncing;
		break;
	}
}

/* The Lazer class!
 * Every 2s it appears or disappear, the same way Target can bounce
 * It is the same height as the window, and a future update should
 * make it horizontal randomly.
 */
function Lazer() {
	Square.call(this, LAZER_SIZE, kloggr.height/pixelDensity, "../assets/lazer.svg");

	this.State = {
		Inactive:"Inactive",
		On:"On",
		Off:"Off"
	};

	this.accumulator = 0;
	this.switch_time = 2; // Time between 2 states
	this.state = this.State.On;
}

Lazer.prototype = Object.create(Enemy.prototype);

Lazer.prototype.respawnHelper = function(gameobjects, max_x, max_y) {
	Square.prototype.respawn.call(this, gameobjects, max_x, max_y);
	this.y = 0;
}


// Respawns far from the player
Lazer.prototype.respawn = function(gameobjects, max_x, max_y) {
	var player;

	var len = gameobjects.length;
	for (var i = 0; i < len; i++) {
		if (gameobjects[i] instanceof Player) {
			player = gameobjects[i];
		}
	}

	do {
		Square.prototype.respawnFarFrom
		    .call(this, gameobjects, max_x, max_y, player, player.width*3, this.respawnHelper);
	} while (intersect(this, player));

	this.accumulator = 0;
	this.setState(this.State.On);
};

// Same as Target but the Lazer is static
Lazer.prototype.update = function(delta_t) {
	if (this.state === this.State.Inactive) {
		return;
	}

	this.accumulator += delta_t;
	if (this.accumulator > this.switch_time) {
		this.accumulator = 0;

		if (this.state === this.State.On)
			this.setState(this.State.Off);
		else
			this.setState(this.State.On);
	}
};

Lazer.prototype.setState = function(st) {
	this.state = st;

	if (st === this.State.On) {
		this.enable();
	} else if (st === this.State.Off) {
		this.disable();
	}
}

// Reset the Lazer's state to On when it respawns
Lazer.prototype.updateState = function(score) {
	switch (score) {
	case 10:
		this.setState(this.State.On);
		break;
	}
}

/* Horizontal Lazer! Green > all
 */
function HorizontalLazer() {
	Square.call(this, kloggr.width/pixelDensity, LAZER_SIZE, "../assets/lazer_horizontal.svg");

	this.State = {
		Inactive:"Inactive",
		On:"On",
		Off:"Off"
	};

	this.accumulator = 0;
	this.switch_time = 1.5;
	this.state = this.State.On;
}

HorizontalLazer.prototype = Object.create(Lazer.prototype);

HorizontalLazer.prototype.respawnHelper = function(gameobjects, max_x, max_y) {
	Square.prototype.respawn.call(this, gameobjects, max_x, max_y);
	this.x = 0;
}

////////////////////////// kloggr.js /////////////////////////////
/* The class that handles the game's flow
 * It initializes the game objects like Player, Target and enemies,
 * it handles the inputs and updates the state of the game objects
 * as the game progresses. It moves the objects according to their
 * speed and the time passed.
 * It has different states like Playing, Paused...
 * It can communicate to the external loop with events via getEvents()
 *
 * A basic external loop would do:
 *  - manage input and pass though handleTouchMove/setKeyState/...
 *  - call Kloggr.collisionDetection()
 *  - call Kloggr.update()
 *  - handle events with getEvents and react accordingly
 */
function Kloggr(width, height) {
	this.width = width;
	this.height = height;

	this.restart();
	this.state = Kloggr.State.Playing;
}

Kloggr.State = {
	Playing:"Playing",
	Paused:"Paused",
	Dead:"Dead",
};

Kloggr.Events = {
	NewHighscore:"NewHighscore",
	StateChanged:"StateChanged",
	ScoreChanged:"ScoreChanged",
	TargetReached:"TargetReached",
};

// Reset default values.
// Used when the player dies, or at the first launch
Kloggr.prototype.restart = function() {
	// Set default values
	this.state = Kloggr.State.Playing;
	this.events = [];
	this.touchmoves = [0, 0];
	this.score = 0;
	this.counter = 0;
	this.enemy_density = 5; // Enemies per 10cm²

	// Spawn gameobjects
	this.respawnAll(true);
};

// Either respawn only the necessary or regenerate every object
Kloggr.prototype.respawnAll = function(full_restart) {
	if (this.gameobjects)
		this.disableAll();

	if (!full_restart) {
		var player_x = this.player.x;
		var player_y = this.player.y;

		this.player.respawn(this.gameobjects, this.width, this.height);
		this.target.respawn(this.gameobjects, this.width, this.height);

		this.player.x = player_x;
		this.player.y = player_y;
	} else {
		if (this.gameobjects) {
			for (var i = 0; i < this.gameobjects.length; i++) {
				this.gameobjects[i].object.destroy();
			}
		}

		this.gameobjects = [];
		this.gameobjects.push(new Player());
		this.gameobjects.push(new Target());

		this.player = this.gameobjects[0];
		this.target = this.gameobjects[1];

		this.player.respawn(this.gameobjects, this.width, this.height);
		this.target.respawn(this.gameobjects, this.width, this.height);
	}

	this.respawnEnemies();
	this.enableAll();

	this.player.source = "../assets/player/player.svg";
};

// These two functions make all objects invisible/non collidable
// and vice versa. Used not to see things respawning.
Kloggr.prototype.enableAll = function() {
	for (var i = 0; i < this.gameobjects.length; i++) {
		this.gameobjects[i].enable();
	}
}

Kloggr.prototype.disableAll = function() {
	for (var i = 0; i < this.gameobjects.length; i++) {
		this.gameobjects[i].disable();
	}
}

// Respawns enemies and generate more if needed
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
			this.gameobjects[i].respawn(this.gameobjects, this.width, this.height);
		}
	}
};

// Store the start of the touch to get the start of a vector
Kloggr.prototype.handleTouchStart = function(mouse) {
	this.touchmoves[0] = mouse.x;
	this.touchmoves[1] = mouse.y;
};

// Use the starting point of touch and endpoint to get a direction vector.
// Apply it to the player's direction.
Kloggr.prototype.handleTouchMove = function(mouse) {
	var move_x = mouse.x - this.touchmoves[0];
	var move_y = mouse.y - this.touchmoves[1];

	// Should be done during update(), but hey, lack of funding
	this.player.speed_x += (move_x/pixelDensity)*this.player.accel;
	this.player.speed_y += (move_y/pixelDensity)*this.player.accel;

	this.touchmoves[0] = mouse.x;
	this.touchmoves[1] = mouse.y;
};

// Move objects
Kloggr.prototype.update = function(delta_t) {
	this.counter += delta_t;

	var len = this.gameobjects.length;
	for (var i = 0; i < len; i++) {
		if (this.gameobjects[i].to_update === false) {
			continue;
		}

		this.gameobjects[i].update(delta_t);
	}
};

// Blocks the moving objects from escpaing the window.
// Check if the player reached a target, emits events...
// Check if the player collides with an enemy -> state = Dead
Kloggr.prototype.collisionDetection = function() {
	// Wall collisions
	this.player.collideBox(0, 0, this.width, this.height);
	this.target.collideBox(0, 0, this.width, this.height);

	if (intersect(this.player, this.target)) {
		this.score += 1;
		// Other collisions are useless in this case
		return;
	}

	var len = this.gameobjects.length;
	for (var i = 0; i < len; i++) {
		if (this.gameobjects[i] instanceof Enemy) {
			if (this.gameobjects[i].collidable) {
				if (intersect(this.player, this.gameobjects[i])) {
					console.log("Dead");
					this.state = Kloggr.State.Dead;
					this.newEvent(Kloggr.Events.StateChanged, this.state);
				}
			}
		}
	}
};

// These 2 functions are used to transmit messages
// to the external main loop.
Kloggr.prototype.newEvent = function(evt, val) {
	this.events.push({
		name: evt,
		value: val
	});
};

// Returns the events and their values and clear the event
// queue.
Kloggr.prototype.getEvents = function() {
	var tmp = this.events;
	this.events = [];

	return tmp;
};

// Give the score to every object in case they want to change state, etc...
Kloggr.prototype.updateByScore = function(value) {
	if (!this.gameobjects) {
		return;
	}

	// Allow objects to change based on score
	for (var i = 0; i < this.gameobjects.length; i++) {
		if (this.gameobjects[i].updateState) {
			this.gameobjects[i].updateState(value);
		}
	}

	this.enemy_density += 0.5;

	// Kloggr.score has its own setter that calls
	// Kloggr.newEvents, so no need for it here
	this.newEvent(Kloggr.Events.TargetReached);

	switch (value) {
	case 10:
		var lazer = new Lazer();
		lazer.respawn(this.gameobjects, this.width, this.height);
		this.gameobjects.push(lazer);
		break;
	case 15:
		var h_lazer = new HorizontalLazer();
		h_lazer.respawn(this.gameobjects, this.width, this.height);
		this.gameobjects.push(h_lazer);
		break;
	}
}

// Return the the number of enemies to create
Kloggr.prototype.numberOfEnemies = function() {
	var d = this.enemy_density/(100*100) // enemy/cm²;
	var screen_w = this.width/pixelDensity; // cm
	var screen_h = this.height/pixelDensity; // cm
	var screen_area = screen_w*screen_h; // cm²

	// then (enemy/cm²)*cm² = enemy
	return Math.round(d*screen_area); // enemy
};

// Define getters/setters to automatize things
Object.defineProperty(Kloggr.prototype, 'score', {
	get: function() {
		return this._score;
	},

	set: function(value) {
		this._score = value;
		this.newEvent(Kloggr.Events.ScoreChanged, value);

		this.updateByScore(value);
	}
});

