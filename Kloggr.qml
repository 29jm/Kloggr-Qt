import QtQuick 2.3
import QtQuick.Window 2.0
import Qt.labs.settings 1.0

import "js/kloggr.js" as Game

Rectangle {
	id: kloggrItem
	focus: true
	color: "#34495e"

	property var kloggr: undefined
	property real pixelDensity: Screen.pixelDensity
	property int highscore: 0
	property int score: 0

	signal dead
	signal targetReached
	signal timerChanged(int new_time)
	signal newHighscore()

	Component.onCompleted: {
		Game.pixelDensity = pixelDensity;
		Game.kloggr = this;
		kloggr = new Game.Kloggr(width, height);
	}

	onDead: {
		score = getPoints();
		if (score > highscore) {
			highscore = score;
			newHighscore();
		}
	}

	function play() {
		console.log("play()");
		timer.start();
	}

	function pause() {
		console.log("pause()");
		timer.stop();
	}

	function restart() {
		console.log("restart()");
		kloggr.restart();
		timer.start();
	}

	function getScore() {
		return kloggr.score;
	}

	function getTime() {
		return Math.round(kloggr.counter);
	}

	function getPoints() {
		var score = getScore();
		if (score < 1) {
			return 0;
		}

		var points = score*score-Math.sqrt(getTime());

		if (points < 0) {
			return 0;
		}
		else {
			return Math.round(points);
		}
	}

	function getHighscore() {
		return highscore;
	}

	function handleEvents(event) {
		switch (event.name) {
		case Game.Kloggr.Events.StateChanged:
			updateState();
			break;
		case Game.Kloggr.Events.TargetReached:
			score = getPoints();
			targetReached();
			kloggr.respawnAll();
			break;
		}
	}

	function updateState() {
		switch (kloggr.state) {
		case Game.Kloggr.State.Dead:
			dead();
		}
	}

	MouseArea {
		property bool inTouch: false
		hoverEnabled: true
		anchors.fill: parent
		onPressed: {
			inTouch = true;
			mouse.accepted = true;
			kloggr.handleTouchStart(mouse);
			wave.open(kloggr.player.x, kloggr.player.y);
		}

		onPositionChanged: {
			if (inTouch) {
				mouse.accepted = true;
				kloggr.handleTouchMove(mouse);
			}
		}

		onReleased: {
			inTouch = false;
		}
	}

	Timer {
		id: timer
		interval: 1000/60 // in millisecond
		running: true
		repeat: true

		onTriggered: {
			if (kloggr.state === Game.Kloggr.State.Playing) {
				kloggr.update(1/60); // in seconds
				kloggr.collisionDetection();
			}

			var events = kloggr.getEvents();
			for (var i = 0; i < events.length; i++) {
				handleEvents(events[i]);
			}
		}

		onRunningChanged: {
			if (running) {
				score_timer.start();
			} else {
				score_timer.stop();
			}
		}
	}

	Timer {
		id: score_timer
		interval: 1000
		running: true
		repeat: true

		onTriggered: {
			score = getPoints();
		}
	}

	Wave {
		id: wave
		color: "#3d566e"

		onFinished: {
			wave.color = kloggrItem.color;
			wave.close(0, 0);
		}
	}

	Settings  {
		property alias highscore: kloggrItem.highscore
	}
}
