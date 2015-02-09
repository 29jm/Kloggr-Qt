import QtQuick 2.3

ClickButton {
	height: width
	radius: width/2
	color: "white"

	property alias image: img.source
	property alias imageWidth: img.width
	property real angle: 360

	Image {
		id: img
		sourceSize.height: width
		smooth: true
		fillMode: Image.PreserveAspectFit

		anchors.centerIn: parent
	}

	states: [
		State {
			name: "rotated"
			when: mouseArea.containsMouse === true

			PropertyChanges {
				target: img
				rotation: angle
			}
		}
	]

	transitions: [
		Transition {
			from: ""; to: "rotated"
			reversible: true

			NumberAnimation {
				property: "rotation"
				duration: 500
				easing.type: Easing.InOutQuad
			}
		}
	]
}
