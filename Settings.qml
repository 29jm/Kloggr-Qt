import QtQuick 2.0

Rectangle {
	id: settings
	color: "#4dd0e1"

	anchors.fill: parent

	signal mainMenuClicked
	property bool musicOn: true
	property bool soundOn: true

	Component.onCompleted: {
		settings.forceActiveFocus();
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

		onClicked: {
			if(soundOn) {
				soundOn = false;
				soundBtn.opacity = 0.5;
			}
			else {
				soundOn = true;
				soundBtn.opacity = 1;
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

		onClicked: {
			if(musicOn) {
				musicOn = false;
				musicBtn.opacity = 0.5;
			}
			else {
				musicOn = true;
				musicBtn.opacity = 1;
			}
		}
	}

	RoundButton {
		image: "assets/exit.svg"
		id: exitBtn
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

