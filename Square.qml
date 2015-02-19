import QtQuick 2.3

Item {
	id: square

	property alias source: img.source
	property alias color: rect.color

	Image {
		id: img
		visible: true

		anchors.fill: parent
	}

	Rectangle {
		id: rect
		visible: true

		anchors.fill: parent
	}

	onSourceChanged: {
		if (source !== "") {
			img.visible = true;
			rect.visible = false;
		} else {
			img.visible = false;
			rect.visible = true;
		}
	}

	onOpacityChanged: {
		if (opacity === 0) {
			visible = false;
		} else {
			visible = true;
		}
	}

	Behavior on opacity {
		NumberAnimation {
			duration: 200
		}
	}
}
