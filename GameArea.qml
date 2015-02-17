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

		anchors.top: score_container.top
		anchors.right: score_container.right
		anchors.rightMargin: 5
		anchors.topMargin: -this.width/2
		z: 10

		onClicked: {
			kloggr.restart();
			parent.state = ""
		}
	}

	RoundButton {
		id: exitBtn
		image: "assets/exit.svg"
		angle: 180
		width: parent.height/12
		imageWidth: exitBtn.width/2
		visible: false

		anchors.top: restartBtn.top
		anchors.topMargin: restartBtn.height/2+5
		anchors.horizontalCenter: restartBtn.horizontalCenter

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
		id: pause_container
		width: parent.width*0.7
		height: parent.height/4
		color: "#4dd0e1"
		anchors.centerIn: parent
		visible: false
		Text {
			color: "white"
			text: "Pause"
			font.pixelSize: 40
			smooth: true
			font.family: roboto.name
			anchors.centerIn: parent
		}
	}

	Rectangle {
		id: score_container
		width: parent.width*0.7
		height: parent.height/4
		color: "#4dd0e1"
		anchors.centerIn: parent
		visible: false

		Rectangle {
			width: 2
			height: parent.height*0.90
			anchors.centerIn: parent
		}

		Item {
			width: parent.width/2
			height: parent.height*0.60
			anchors.top: parent.top
			anchors.left: parent.left
			Text {
				id: current_score
				color: "white"
				text: "0"
				font.pixelSize: 40
				smooth: true
				font.family: roboto.name
				anchors.centerIn: parent
			}
		}
		Item {
			width: parent.width/2
			height: parent.height*0.60
			anchors.top: parent.top
			anchors.right: parent.right
			Text {
				id: current_time
				color: "white"
				text: "0"
				font.pixelSize: 40
				smooth: true
				font.family: roboto.name
				anchors.centerIn: parent
			}
		}
		Item {
			id: crown_container
			width: parent.width*0.25
			height: parent.height*0.40
			anchors.left: parent.left
			anchors.bottom: parent.bottom
			Image {
				id: crown
				smooth: true
				fillMode: Image.PreserveAspectFit
				anchors.centerIn: parent
				source: "assets/crown.svg"
			}
		}

		Item {
			id: highscore_container
			width: parent.width*0.25
			height: parent.height*0.40
			anchors.bottom: parent.bottom
			anchors.left: crown_container.right
			Text {
				id: highscore_score
				color: "white"
				text: "0"
				font.pixelSize: 20
				smooth: true
				font.family: roboto.name
				font.bold: true
				anchors.centerIn: parent
			}
		}

		Item {
			width: parent.width*0.25
			height: parent.height*0.40
			anchors.bottom: parent.bottom
			anchors.left: highscore_container.right
			Text {
				id: highscore_time
				color: "white"
				text: "0"
				font.pixelSize: 20
				smooth: true
				font.family: roboto.name
				font.bold: true
				anchors.centerIn: parent
			}
		}
		onVisibleChanged: {
			if (visible) {
				current_score.text = kloggr.getScore();
				current_time.text = kloggr.getTime();
				highscore_score.text = kloggr.getScore();
				highscore_time.text = kloggr.getTime();
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
			//Display pause Container
			PropertyChanges { target: pause_container; visible: true}

			//Display restartBtn
			PropertyChanges { target: restartBtn; visible: true}
			AnchorChanges { target: restartBtn; anchors.top: pause_container.bottom; anchors.verticalCenter: undefined }

			//Display exitBtn
			PropertyChanges { target: exitBtn; visible: true}
			AnchorChanges { target: exitBtn; anchors.top: pause_container.bottom; anchors.verticalCenter: undefined }

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
