import QtQuick 2.0

Rectangle {
	width: img.width; height: img.height

	property alias image: img

	signal buttonClicked
	signal buttonEntered
	signal buttonExited

	MouseArea {
		id: btnArea
		hoverEnabled: true
		anchors.fill: parent

		onClicked: buttonClicked()
		onEntered: buttonEntered()
		onExited: buttonExited()
	}

	Image {
		id: img
	}
}
