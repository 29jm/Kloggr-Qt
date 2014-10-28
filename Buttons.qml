import QtQuick 2.3

Rectangle {
	id: buttonRect

	signal btnClicked()

	property string imgSource
	property string imgId
	property int degree
	property int rectWidth
	property int imgWidth


	width: rectWidth
	height: width
	radius: width/2
	color: "white"

	Image {
		id: imgId
		width: imgWidth
		height: width
		smooth: true
		source: buttonRect.imgSource
		fillMode: Image.PreserveAspectFit
		anchors.centerIn: parent
	}
	MouseArea {
		id: hoverArea
		anchors.fill: parent
		hoverEnabled: true
		onClicked: btnClicked()
	}

	states: State {
		name: "rotated"; when: hoverArea.containsMouse == true
		PropertyChanges {
			target: imgId
			rotation: degree
		}
	}

	transitions: Transition {
		from: ""; to: "rotated"
		reversible: true
		NumberAnimation { property: "rotation"; duration: 500; easing.type: Easing.InOutQuad }
	}
}
