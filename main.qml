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

			anchors.top: parent.top
			anchors.bottom: parent.bottom
			anchors.left: parent.right

			onMainMenuClicked: {
				// Set the MainMenu as visible
				parent.state = "";
			}
		}

		Info {
			id: infoPage
			visible: false

			anchors.top: parent.top
			anchors.bottom: parent.bottom
			anchors.left: parent.right

			onMainMenuClicked: {
				// Set the MainMenu as visible
				parent.state = "";
			}
		}
		Settings {
			id: settingsPage
			visible: false

			anchors.top: parent.top
			anchors.bottom: parent.bottom
			anchors.left: parent.right

			onMainMenuClicked: {
				// Set the MainMenu as visible
				parent.state = "";
			}
		}

		states: [
			State {
				name: "Playing"
				AnchorChanges {
					target: gameArea
					anchors.left: parent.left
					anchors.right: parent.right
				}

				PropertyChanges { target: gameArea; visible: true; state: "" }
			},
			State {
				name: "Settings"

				AnchorChanges {
					target: settingsPage
					anchors.left: parent.left
					anchors.right: parent.right
				}

				PropertyChanges { target: settingsPage; visible: true }
			},
			State {
				name: "Info"

				AnchorChanges {
					target: infoPage
					anchors.left: parent.left
					anchors.right: parent.right
				}

				PropertyChanges { target: infoPage; visible: true }
			}
		]

		transitions: Transition {
			AnchorAnimation {
				duration: 500
				easing.type: Easing.InOutBack
			}
		}
	}
}
