import QtQuick 2.3
import QtQuick.Controls 1.2
import QtMultimedia 5.0

Rectangle {
	id: gameArea
	color: "#34495e"

	signal mainMenuClicked



	Kloggr {
		id: kloggr

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom

		onDead: {
			deadSound.play();
			parent.state = "Dead";
		}

		onScoreChanged: {
			if (new_score !== 0) {
				oneUpSound.play();
				console.log(SettingsMenu.soundOn);
			}
		}

		onNewHighscore: {
			highscoreSound.play();
		}
	}

	RoundButton {
		id: restartBtn
		image: "assets/reload.svg"
		angle: 360
		width: parent.height/8
		imageWidth: restartBtn.width/2
		visible: false

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: parent.width/4

		onClicked: {
			kloggr.restart();
			parent.state = ""
		}
	}

	RoundButton {
		id: exitBtn
		image: "assets/exit.svg"
		angle: 180
		width: parent.height/8
		imageWidth: exitBtn.width/2
		visible: false

		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: parent.width/4

		onClicked: mainMenuClicked()
	}

	Rectangle {
		id: pauseBtn
		height: 6*kloggr.pixelDensity
		width: height
		color: "#00bcd4"
		opacity: 0.8

		anchors.left: parent.left
		anchors.bottom: parent.bottom

		Image {
			id: pauseImg
			fillMode: Image.PreserveAspectFit
			smooth: true
			anchors.centerIn: parent
			source: "assets/pause.png"
		}

		MouseArea {
			anchors.fill: parent
			onClicked: {
				parent.parent.state = (parent.parent.state == "" ? "Paused" : "");
				if (parent.parent.state == "Paused") {
					kloggr.pause();
				}
				else {
					kloggr.play();
				}
			}
		}
	}

	Rectangle {
		id: score_container
		width: parent.width*0.90
		height: parent.height/2
		color: "#00bcd4"
		anchors.centerIn: parent
		visible: false

		Grid {
			id: score_grid
			columns: 2
			rows: 2
			anchors.fill: parent

			Text {
				id: current_score
				color: "white"
				text: "0"
				font.pixelSize: 20
				smooth: true
				font.family: roboto.name
			}
			Text {
				id: current_time
				color: "white"
				text: "0"
				font.pixelSize: 20
				smooth: true
				font.family: roboto.name
			}
			Text {
				id: highscore_score
				color: "white"
				text: "0"
				font.pixelSize: 20
				smooth: true
				font.family: roboto.name
			}
			Text {
				id: highscore_time
				color: "white"
				text: "0"
				font.pixelSize: 20
				smooth: true
				font.family: roboto.name
			}
		}

		onVisibleChanged: {
			if (visible) {
				current_score.text = kloggr.getScore();
				current_time.text = kloggr.counter;
				highscore_score.text = kloggr.getScore();
				highscore.text = kloggr.counter;
			}
		}

		FontLoader {
			id: roboto;
			source: "assets/ttf"
		}
	}

	onVisibleChanged: {
		if (visible) {
			kloggr.play();
		}
	}

	states: [
		State {
			name: "Paused"
			//Display restartBtn
			PropertyChanges { target: restartBtn; visible: true}
			//Display exitBtn
			PropertyChanges { target: exitBtn; visible: true}
			//change pauseBtn img
			PropertyChanges { target: pauseImg; source: "assets/gamePlay.png"}
		},
		State {
			name: "Dead"
			//Display and move restart button onDead
			PropertyChanges { target: restartBtn; visible: true; }
			AnchorChanges { target: restartBtn; anchors.top: score_container.bottom; anchors.verticalCenter: undefined }
			//Display and move exit button onDead
			PropertyChanges { target: exitBtn; visible: true; }
			AnchorChanges { target: exitBtn; anchors.top: score_container.bottom; anchors.verticalCenter: undefined }
			//Display Score and hide pause button
			PropertyChanges { target: score_container; visible: true; }
			PropertyChanges { target: pauseBtn; visible: false }
		}
	]

	SoundEffect {
		id: oneUpSound
		source: "qrc:/assets/woosh.wav"
	}

	SoundEffect {
		id: deadSound
		source: "qrc:/assets/gameover.wav"
	}

	SoundEffect {
		id: highscoreSound
		source: "qrc:/assets/highscore.wav"
	}
}
