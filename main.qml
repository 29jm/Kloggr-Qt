import QtQuick 2.3
import QtQuick.Window 2.0

Window {
	id: window
	visible: true
	minimumWidth: 420
	minimumHeight: 590

	Rectangle {
		id: page
		anchors.fill: parent

		MainMenu {
			id: mainmenu
			anchors.fill: parent

			onPlayClicked: parent.state = "Playing"
			onSettingsClicked: parent.state = "Settings"
			onInfoClicked: parent.state = "Info"
		}

		GameArea {
			id: gameArea
			visible: false
			anchors.fill: parent

			onMainMenuClicked: {
				// Set the MainMenu as visible
				parent.state = "";
			}
		}

		states: [
			State {
				name: "Playing"
				PropertyChanges { target: mainmenu; visible: false }
				PropertyChanges { target: gameArea; visible: true }
				PropertyChanges { target: gameArea; state: "" }
			},
			State {
				name: "Settings"
			},
			State {
				name: "Infos"
			}
		]
	}
}
