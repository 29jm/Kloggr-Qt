import QtQuick 2.3

ClickButton {
	height: width
	radius: width/2
	color: "white"

	property alias image: img.source
	property alias imageWidth: img.width
	property real angle: 360

	onClicked: img.rotation = (img.rotation ? 0 : angle)

	Image {
		id: img
		sourceSize.height: width
		smooth: true
		fillMode: Image.PreserveAspectFit

		anchors.centerIn: parent

		Behavior on rotation {
			NumberAnimation {
				duration: 500
				easing.type: Easing.InOutQuad
			}
		}
	}
}
