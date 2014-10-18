import QtQuick 2.0

import "js/kloggr.js" as Game

Rectangle {
	property var kloggr: undefined

	function play() {
		update_timer.start()
	}

	function pause() {
		update_timer.stop();
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

		interval: 1000/60
		running: false
		repeat: true
		onTriggered: {
			kloggr.update(1000/60);
		}
	}
}
