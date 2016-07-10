import QtQuick 2.0
import Qt.labs.settings 1.0

Rectangle {
	id: settings
	color: "#4dd0e1"

	property bool musicOn: true
	property bool soundOn: true

	signal mainMenuClicked

	Component.onCompleted: {
		settings.forceActiveFocus();
	}

	Settings {
		property alias musicOn: settings.musicOn
		property alias soundOn: settings.soundOn
	}

	RoundButton {
		id: soundBtn
		image: "assets/music.svg"
		angle: 360
		width: parent.height/8
		imageWidth: soundBtn.width/2

		anchors.left: parent.left
		anchors.leftMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/2-this.width/2

		opacity: soundOn ? 1 : 0.5

		onClicked: {
			if(soundOn) {
				soundOn = false;
			} else {
				soundOn = true;
			}
		}

		Behavior on opacity {
			NumberAnimation {
				duration: 200
			}
		}
	}

	RoundButton {
		image: "assets/music-box.svg"
		id: musicBtn
		angle: 360
		width: parent.height/8
		imageWidth: musicBtn.width/2

		anchors.right: parent.right
		anchors.rightMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/2-this.width/2

		opacity: musicOn ? 1 : 0.5

		onClicked: {
			if(musicOn) {
				musicOn = false;
			} else {
				musicOn = true;
			}
		}

		Behavior on opacity {
			NumberAnimation {
				duration: 200
			}
		}
	}

	RoundButton {
		image: "assets/exit.svg"
		id: exitBtn
		color: "#00bcd4"
		angle: 360
		width: parent.height/8
		imageWidth: musicBtn.width/2

		anchors.right: parent.right
		anchors.rightMargin: parent.width/2-this.width/2
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/3-this.width

		onClicked: mainMenuClicked()
	}

	Keys.onReleased: {
		if (event.key === Qt.Key_Back) {
			mainMenuClicked();
			event.accepted = true;
		}
	}
}

