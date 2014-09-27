import QtQuick 2.0
import QtQuick.Controls 1.2

Rectangle {
	width: img.width; height: img.height
	signal buttonClicked()

	MouseArea {
		id: btnArea
		hoverEnabled: true
		anchors.fill: parent

		onClicked: buttonClicked()
	}

	states: State {
		name: "rotated"; when: btnArea.containsMouse == true
		PropertyChanges {
			target: img; rotation: 360
		}
	}

	transitions: Transition {
		from: ""; to: "rotated"
		NumberAnimation { property: "rotation"; duration: 500; easing.type: Easing.InOutQuad }
	}

	Image {
		id: img
		source: "play.png"
	}
}
