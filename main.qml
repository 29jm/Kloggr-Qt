import QtQuick 2.3
import QtQuick.Window 2.0

Window {
	visible: true
	id: window
	width: 420; height: 590

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

			onMainMenuClicked: {
				console.log("mainmenu clicked");
				parent.state = ""
				state = ""
			}

			onVisibleChanged: {
				if (visible) {
					gamearea.kloggr.play();
				}
			}
		}

		states: [
			State {
				name: "Playing"
				PropertyChanges { target: mainmenu; visible: false }
				PropertyChanges { target: gamearea; visible: true }
			}
		]
	}
}
