import QtQuick 2.3
import QtQuick.Window 2.0

Window {
	id: window
	visible: true
	minimumWidth: 420
	minimumHeight: 590

	Rectangle {
		id: page

		property var view

		anchors.fill: parent

		function loadView(new_view) {
			fadeIn.stop(); fadeOut.start();
			view = new_view;
		}

		Loader {
			id: pageLoader
			source: "MainMenu.qml"
			focus: true
			anchors.fill: parent

			onLoaded: {
				fadeOut.stop(); fadeIn.start();
			}

			Keys.onReleased: {
				if (event.key === Qt.Key_Back) {
					event.accepted = true;
				}
			}
		}

		OpacityAnimator {
			id: fadeIn
			target: page
			from: 0
			to: 1
			duration: 400
		}

		OpacityAnimator {
			id: fadeOut
			target: page
			from: 1
			to: 0
			duration: 200

			onStopped: {
				pageLoader.source = page.view;
			}
		}

		Connections {
			target: pageLoader.item
			ignoreUnknownSignals: true

			onMainMenuClicked: { page.loadView("MainMenu.qml"); }
			onPlayClicked: { page.loadView("GameArea.qml"); }
			onInfoClicked: { page.loadView("Info.qml"); }
			onSettingsClicked: { page.loadView("SettingsMenu.qml"); }
		}
	}
}
