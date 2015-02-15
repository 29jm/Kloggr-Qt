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
		rotation: mouseArea.containsMouse ? angle : 0

		anchors.centerIn: parent

		Behavior on rotation {
			NumberAnimation {
				duration: 500
				easing.type: Easing.InOutQuad
			}
		}
	}
}
