import QtQuick 2.3
import QtQuick.Window 2.0

Window {
	id: window
	visible: true
	minimumWidth: 420
	minimumHeight: 590

	Rectangle {
		id: page
		color: "#4dd0e1"

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
			//	if (page.view !== "MainMenu.qml") {
					fadeOut.stop(); fadeIn.start();
			//	}
			}
		}

		NumberAnimation {
			id: fadeIn
			target: pageLoader.item
			property: "y"
			from: page.height
			to: 0
			duration: 250
			easing.type: Easing.OutCirc
		}

		NumberAnimation {
			id: fadeOut
			target: pageLoader.item
			property: "y"
			from: 0
			to: -page.height
			duration: 250

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

		Component.onCompleted: {
			page.forceActiveFocus();
		}

		Keys.onReleased: {
			if (event.key === Qt.Key_Back) {
				event.accepted = true;
				window.close();
			}
		}
	}
}
