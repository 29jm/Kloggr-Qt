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

				PropertyChanges { target: gameArea; state: "" }
			},
			State {
				name: "Settings"
			},
			State {
				name: "Info"
				AnchorChanges {
					target: infoPage
					anchors.left: parent.left
					anchors.right: parent.right
				}
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
