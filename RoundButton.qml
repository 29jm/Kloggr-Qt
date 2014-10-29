import QtQuick 2.3

Rectangle {
	signal clicked

	property alias source: img.source
	property int angle: 360

	width: img.width
	height: width
	radius: width/2
	color: "white"

	onWidthChanged: img.width = width;
	onHeightChanged: img.height = height;

	Image {
		id: img
		width: parent.width
		height: parent.height
		smooth: true
		fillMode: Image.PreserveAspectFit
		anchors.centerIn: parent
	}

	MouseArea {
		id: hoverArea
		anchors.fill: parent
		hoverEnabled: true
		onClicked: parent.clicked()
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
}
