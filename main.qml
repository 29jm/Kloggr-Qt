import QtQuick 2.3
import QtQuick.Window 2.0

import "js/main.js" as Main

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

			onPauseClicked: {
				console.log("timer stopped")
				timer.stop()
			}

			onPlayClicked: {
				console.log("timer resumed")
				timer.start()
			}

			onMainMenuClicked: {
				console.log("mainmenu clicked");
				parent.state = ""
				state = ""
			}
		}

		states: [
			State {
				name: "Playing"
				PropertyChanges { target: mainmenu; visible: false }
				PropertyChanges { target: gamearea; visible: true }
				PropertyChanges { target: timer; running: true }
			}
		]

		Timer {
			id: timer
			interval: 3 // hopefully in millisecond
			running: false
			repeat: true
			onTriggered: {
				// gamearea.update()
			}
		}
	}
}
