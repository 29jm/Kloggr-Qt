import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
	property alias kloggr: kloggr
	color: "#34495e"

	signal mainMenuClicked

	function play() {
		kloggr.play();
	}

	Kloggr {
		id: kloggr

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: pauseBtn.top

		onDead: parent.state = "Dead"
	}

	GameButton {
		id: restartBtn
		text: "Restart"
		visible: false

		anchors.left: pauseBtn.right // Begins invisible on the right
		anchors.margins: 5

		onClicked: {
			kloggr.restart();
			parent.state = ""
		}
	}

	GameButton {
		id: exitBtn
		text: "Exit"
		visible: false

		anchors.left: restartBtn.right
		anchors.margins: 5

		onClicked: {
			kloggr.restart();
			mainMenuClicked()
		}
	}

	GameButton {
		id: pauseBtn
		text: "Pause"

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.margins: 5

		onClicked: {
			parent.state = (parent.state == "" ? "Paused" : "")
			if (parent.state == "Paused") {
				kloggr.pause();
			}
			else {
				kloggr.play();
			}
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
			PropertyChanges { target: pauseBtn; text: "Play" }
			// Restart button
			PropertyChanges { target: restartBtn; visible: true }
			AnchorChanges {
				target: restartBtn
				anchors.left: parent.left;
				anchors.right: parent.horizontalCenter
				anchors.top: undefined
				anchors.bottom: pauseBtn.top
			}

			PropertyChanges { target: exitBtn; visible: true }
			AnchorChanges {
				target: exitBtn
				anchors.left: restartBtn.right
				anchors.right: parent.right
				anchors.top: undefined
				anchors.bottom: pauseBtn.top
			}
		},
		State {
			name: "Dead"
			PropertyChanges { target: restartBtn; visible: true }
			PropertyChanges { target: exitBtn; visible: true }
			AnchorChanges {
				target: exitBtn
				anchors.left: parent.left
				anchors.right: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter
			}

			AnchorChanges {
				target: restartBtn
				anchors.left: parent.horizontalCenter
				anchors.right: parent.right
				anchors.verticalCenter: parent.verticalCenter
			}

			PropertyChanges { target: pauseBtn; visible: false}
		}

	]
}
