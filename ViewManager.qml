import QtQuick 2.3

Rectangle {
	id: page
	color: "#4dd0e1"

	property var view

	anchors.fill: parent

	function loadView(new_view) {
		view = new_view;
		fadeIn.stop(); fadeOut.start();
	}

	Loader {
		id: pageLoader
		source: "MainMenu.qml"
		focus: true
		anchors.fill: parent

		onLoaded: {
			fadeOut.stop(); fadeIn.start();
		}
	}

	NumberAnimation {
		id: fadeIn
		target: pageLoader.item
		property: "y"
		from: page.view === "MainMenu.qml" ? page.height : -page.height
		to: 0
		duration: 250
		easing.type: Easing.OutCirc
	}

	NumberAnimation {
		id: fadeOut
		target: pageLoader.item
		property: "y"
		from: 0
		to: page.view === "MainMenu.qml" ? -page.height : page.height
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
			Qt.quit();
		}
	}
}
