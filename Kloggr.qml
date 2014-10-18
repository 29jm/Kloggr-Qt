import QtQuick 2.0

import "js/kloggr.js" as Game

Rectangle {
	property var kloggr: undefined

	MouseArea {
		anchors.fill: parent
	}

	Component.onCompleted: {
		Game.kloggr = this;
		kloggr = new Game.Kloggr(540, 590);
	}
}
