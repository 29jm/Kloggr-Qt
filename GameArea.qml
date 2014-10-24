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

	Rectangle {
		id: restartBtn
		height: parent.height/8
		width: parent.height/8
		radius: width*0.5
		color: "#1abc9c"
		visible: false

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: parent.width/4

		Image {
			anchors.fill: parent
			id: restartImg
			fillMode: Image.PreserveAspectFit
			smooth: true
			anchors.centerIn: parent
			source: "assets/replay.png"
		}

		MouseArea{
			anchors.fill: parent
			onClicked: {
				kloggr.restart();
				gameArea.state = ""
			}
		}
	}

	Rectangle {
		id: exitBtn
		height: parent.height/8
		width: parent.height/8
		color: "#1abc9c"
		radius: width*0.5
		visible: false

		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: parent.width/4

		Image {
			id: exitImg
			source: "assets/exit.png"
			fillMode: Image.PreserveAspectFit
			smooth: true

			anchors.fill: parent
			anchors.centerIn: parent
		}

		MouseArea{
			anchors.fill: parent
			onClicked: {
				kloggr.restart();
				mainMenuClicked()
			}
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

		Text {
			id: score
			color: "white"
			text: "0"
			anchors.centerIn: parent
			font.pixelSize: 50
			smooth: true
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
