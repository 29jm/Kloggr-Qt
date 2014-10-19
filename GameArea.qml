import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Item {
	property alias kloggr: kloggr

	signal pauseClicked
	signal mainMenuClicked
	signal playClicked

	Kloggr {
		id: kloggr

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: pauseBtn.top
		anchors.bottomMargin: 5
	}

	GameButton {
		id: restartBtn
		text: "Restart"
		visible: false

		anchors.left: pauseBtn.right // Begins invisible on the right
		anchors.margins: 5

		onClicked: kloggr.restart();
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
				pauseClicked()
			}
			else {
				playClicked()
			}
		}
	}

	onPlayClicked: kloggr.play();
	onPauseClicked: kloggr.pause();

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
			// Exit button
			PropertyChanges { target: exitBtn; visible: true }
			AnchorChanges {
				target: exitBtn
				anchors.left: restartBtn.right
				anchors.right: parent.right
				anchors.top: undefined
				anchors.bottom: pauseBtn.top
			}
		}
	]
}
