import QtQuick 2.3

import "js/kloggr.js" as Game

Item {
	property var kloggr: undefined

	focus: true

	signal dead
	signal timerChanged()
    signal scoreChanged()

	function play() {
		if (kloggr.state != Game.Kloggr.State.Playing) {
			console.log("play() called but game must be restarted");
        }
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
		return kloggr.score
	}

	function handleEvents(event) {
		switch (event.name) {
		case Game.Kloggr.Events.StateChanged:
			updateState();
			break;
		case Game.Kloggr.Events.NewHighscore:
			break;
		case Game.Kloggr.Events.ScoreChanged:
		   scoreChanged(event.value); // TODO: missing handler
			break;
		case Game.Kloggr.Events.TargetReached:
			kloggr.respawnAll();
			break;
		case Game.Kloggr.Events.TimeChanged:
			timerChanged(event.value); // TODO: missing handler
			break;
		}
	}

	function updateState() {
		switch (kloggr.state) {
		case Game.Kloggr.State.Dead:
			dead();
		}
	}

	Keys.onPressed: {
		kloggr.setKeyState(event.key, true);
		event.accepted = true;
	}

	Keys.onReleased: {
		kloggr.setKeyState(event.key, false);
		event.accepted = true;
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

	onVisibleChanged: {
		if (visible && kloggr === undefined) {
			Game.kloggr = this;
			kloggr = new Game.Kloggr(width, height);
		}
		else if (visible && kloggr.state == Game.Kloggr.Playing) {
			// Resume after re-switching
			play();
		}
		else if (!visible) {
			// Pause when switching apps
			pause();
		}
	}

	Timer {
		id: timer

		interval: 1000/60 // in millisecond
		running: false
		repeat: true
		onTriggered: {
			if (kloggr.state == Game.Kloggr.State.Playing) {
				kloggr.handleKeys();
				kloggr.update(1/60); // in seconds
				kloggr.collisionDetection();
			}

			var events = kloggr.getEvents();
			for (var i = 0; i < events.length; i++) {
				handleEvents(events[i]);
			}
		}
	}
}
