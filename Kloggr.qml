import QtQuick 2.0

import "js/kloggr.js" as Game

Rectangle {
	MouseArea {
		anchors.fill: parent
	}

	Component.onCompleted: {
		Game.kloggr = this;
	}
}
