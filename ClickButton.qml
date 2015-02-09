import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
	property alias sound: click.source
	property alias mouseArea: mouseArea

	signal clicked

	MouseArea {
		id: mouseArea
		hoverEnabled: true

		anchors.fill: parent

		onClicked: {
			click.play();
			parent.clicked();
		}
	}

	SoundEffect {
		id: click
		source: "qrc:/assets/click.wav"
	}
}

