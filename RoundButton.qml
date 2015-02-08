import QtQuick 2.3
import QtMultimedia 5.0

Rectangle {
	id: btn
	height: width
	radius: width/2
	color: "white"

	property alias source: img.source
	property alias imgWidth: img.width
	property alias btnWidth: btn.width
	property alias audio: click_sound.source
	property int angle: 360

	signal clicked

	Image {
		id: img
		height: width
		smooth: true
		fillMode: Image.PreserveAspectFit
		anchors.centerIn: parent
	}

	MouseArea {
		id: hoverArea
		anchors.fill: parent
		hoverEnabled: true
		onClicked: {
			click_sound.play();
			btn.clicked()
		}
	}

	states: State {
		name: "rotated"; when: hoverArea.containsMouse == true
		PropertyChanges {
			target: img
			rotation: angle
		}
	}

	transitions: Transition {
		from: ""; to: "rotated"
		reversible: true
		NumberAnimation {
			property: "rotation"
			duration: 500
			easing.type: Easing.InOutQuad
		}
	}

	SoundEffect {
		id: click_sound
		source: "qrc:/assets/click.wav"
	}
}
