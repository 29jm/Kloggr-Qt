import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Item {
	signal pauseClicked
	signal mainMenuClicked
	signal playClicked

	Canvas {
		id: canvas
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: pauseBtn.top
		anchors.topMargin: 5
		anchors.leftMargin: 5
		anchors.rightMargin: 5
		anchors.bottomMargin: 5
	}

	GameButton {
		id: restartBtn
		text: "Restart"
		visible: false

		anchors.left: pauseBtn.right // Begins invisible on the right
		anchors.leftMargin: 5
		anchors.rightMargin: 5
		anchors.bottomMargin: 5
	}

	GameButton {
		id: exitBtn
		text: "Exit"
		visible: false

		anchors.left: restartBtn.right
		anchors.leftMargin: 5
		anchors.rightMargin: 5
		anchors.bottomMargin: 5
	}

	GameButton {
		id: pauseBtn
		text: "Pause"

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.leftMargin: 5
		anchors.rightMargin: 5
		anchors.bottomMargin: 5

		onClicked: {
			parent.state = (parent.state == "" ? "Paused" : "")
			if (parent.state == "Paused") {
				pausedClicked()
			}
		}
	}

	states: [
		State {
			name: "Paused"
			PropertyChanges { target: pauseBtn; text: "Play" }
			AnchorChanges { target: canvas; anchors.bottom: restartBtn.top }
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
