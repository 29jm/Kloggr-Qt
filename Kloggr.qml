import QtQuick 2.0

import "js/kloggr.js" as Game

Rectangle {
	property var kloggr: undefined
	focus: true

	function play() {
		update_timer.start();
	}

	function pause() {
		update_timer.stop();
	}

	function handleEvents(event) {
		switch (event.name) {
		case Game.Kloggr.Events.StateChanged:
			break;
		case Game.Kloggr.Events.NewHighscore:
			break;
		case Game.Kloggr.Events.ScoreChanged:
			break;
		case Game.Kloggr.Events.TargetReached:
			kloggr.respawnAll();
			break;
		case Game.Kloggr.Events.TimeChanged:
			break;
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
		anchors.fill: parent
	}

	Component.onCompleted: {
		Game.kloggr = this;
		kloggr = new Game.Kloggr(420, 590);
		console.log(parent.width+";"+parent.height);
	}

	Timer {
		id: update_timer

		interval: 1000/60 // in millisecond
		running: false
		repeat: true
		onTriggered: {
			kloggr.handleKeys();
			kloggr.update(1/60); // in seconds
			kloggr.collisionDetection();

			var events = kloggr.getEvents();
			for (var i = 0; i < events.length; i++) {
				handleEvents(events[i]);
			}
		}
	}
}
