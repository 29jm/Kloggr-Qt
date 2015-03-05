import QtQuick 2.3

ClickButton {
	height: width
	radius: width/2
	color: "white"

	property alias image: img.source
	property alias imageWidth: img.width
	property real angle: 360

	onPressed: state = (state == "" ? "rotated" : "")
	onExited: state = ""

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
			PropertyChanges {
				target: img
				rotation: angle
			}
		}
	]

	transitions: [
		Transition {
			NumberAnimation {
				property: "rotation"
				duration: 250
			}
		}
	]
}
