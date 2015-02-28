import QtQuick 2.3
import QtQuick.Window 2.0
import Qt.labs.settings 1.0

import "js/kloggr.js" as Game

Item {
	id: kloggrItem
	focus: true

	property var kloggr: undefined
	property real pixelDensity: Screen.pixelDensity
	property int highscore: 0
	property real highscore_time: 0
	property bool hasBeatenHighscore: false

	signal dead
	signal timerChanged(int new_time)
	signal scoreChanged(int new_score)
	signal newHighscore(int new_highscore)

	Component.onCompleted: {
		Game.kloggr = this;
		kloggr = new Game.Kloggr(width, height);
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
		return kloggr._score;
	}

	function getTime() {
		return Math.round(kloggr.counter);
	}

	function getPoints() {
		var points = getScore()*getScore()-Math.sqrt(getTime());
		if (kloggr._score<1) {
			return 0
		}
		else if (points<0) {
			return Math.round(Math.abs(points)/getTime())+1;
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
		case Game.Kloggr.Events.NewHighscore:
			highscore = event.value;
			if (!hasBeatenHighscore) {
				hasBeatenHighscore = true;
				newHighscore(event.value);
			}
			break;
		case Game.Kloggr.Events.ScoreChanged:
		   scoreChanged(event.value); // TODO: missing handler
			break;
		case Game.Kloggr.Events.TargetReached:
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
	}

	Settings  {
		property alias highscore: kloggrItem.highscore
	}
}
