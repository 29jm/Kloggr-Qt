import QtQuick 2.3

Rectangle {
	id: btn
	signal clicked

	property alias source: img.source
	property alias imgWidth: img.width
	property alias btnWidth: btn.width
	property int angle: 360

	height: width
	radius: width/2
	color: "white"

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
