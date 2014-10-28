import QtQuick 2.3
import QtQuick.Controls 1.2


Rectangle {
	id: gameArea
	color: "#34495e"

	property alias kloggr: kloggr

	signal mainMenuClicked

	Kloggr {
		id: kloggr

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom

		onDead: parent.state = "Dead"
	}

	Buttons {
		id: restartBtn
		imgSource: "assets/replay.png"
		imgId: "restartImg"
		degree: -360
		rectWidth: parent.height/8
		imgWidth: 60
		visible: false

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: parent.width/4

		onBtnClicked: {
			kloggr.restart();
			gameArea.state = ""
		}
	}

	Buttons {
		id: exitBtn
		imgSource: "assets/exit.png"
		imgId: "exitImg"
		degree: 180
		rectWidth: parent.height/8
		imgWidth: 60
		visible: false

		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: parent.width/4

		onBtnClicked: {
			kloggr.restart();
			mainMenuClicked()
		}
	}

	Rectangle {
		id: pauseBtn
		height: 40
		width: 40
		color: "#1abc9c"
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
				gameArea.state = (gameArea.state == "" ? "Paused" : "")
				if (parent.state == "Paused") {
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
		width: parent.height/4
		height: width
		color: "#1abc9c"
		radius: width/2
		visible: false

		anchors.centerIn: parent

		onVisibleChanged: {
			if (visible) {
				score.text = kloggr.getScore();
			}
		}

		FontLoader {
			id: roboto;
			source: "assets/roboto/Roboto-Light.ttf"
		}
		Text {
			id: score
			color: "white"
			text: "0"
			anchors.centerIn: parent
			font.pixelSize: 50
			smooth: true
			font.family: roboto.name
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
			PropertyChanges {target: restartBtn; visible: true}
			//Display exitBtn
			PropertyChanges {target: exitBtn; visible: true}
			//change pauseBtn img
			PropertyChanges {target: pauseImg; source: "assets/gamePlay.png"}
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
}
