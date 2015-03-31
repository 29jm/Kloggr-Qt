import QtQuick.Window 2.0
import QtQuick 2.3

Window {
	id: window
	visible: true
	minimumWidth: 420
	minimumHeight: 590

	property real minimumTime: 750

	Rectangle {
		id: splashscreen
		anchors.fill: parent

		Image {
			source: "assets/splashscreen.svg"
			anchors.fill: parent
		}

		Component.onCompleted: mainloader.source = "ViewManager.qml"
	}

	Loader {
		id: mainloader
		asynchronous: true

		function enable() {
			anchors.fill = parent
		}
	}

	Timer {
		id: timer
		interval: 100
		repeat: true
		running: true
		triggeredOnStart: true

		property int now: 0

		onTriggered: {
			now += 100

			if (mainloader.status === Loader.Ready && now > minimumTime) {
				mainloader.enable();
				repeat = false;
			}
		}
	}
}
