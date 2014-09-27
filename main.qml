import QtQuick 2.0
import QtQuick.Window 2.2

Window {
	visible: true
	id: window
	width: 320; height: 480

	Rectangle {
		id: page
		anchors.fill: parent

		MainMenu {
			id: mainmenu
			anchors.fill: parent

			onPlayClicked: parent.state = "Playing"
		}

		GameArea {
			id: gamearea
			visible: false
			anchors.fill: parent

			onPauseClicked: timer.stop()
			onMainMenuClicked: parent.state = ""
		}

		states: [
			State {
				name: "Playing"
				PropertyChanges { target: mainmenu; visible: false }
				PropertyChanges { target: gamearea; visible: true }
				PropertyChanges { target: timer; running: true }
			},
			State {
				name: "Paused"

			}

		]

		Timer {
			id: timer
			interval: 3 // hopefully in millisecond
			running: false
			repeat: true
			onTriggered: /*js call to mainloop*/ function(){}
		}
	}
}
