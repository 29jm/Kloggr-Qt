import QtQuick 2.0
import QtMultimedia 5.0
import Qt.labs.settings 1.0

Rectangle {
	id: btn

	property alias sound: click.source
	property alias mouseArea: mouseArea
	property bool soundOn: true

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
		muted: !btn.soundOn
	}

	Settings {
		id: settings
		property alias soundOn: btn.soundOn
	}
}
