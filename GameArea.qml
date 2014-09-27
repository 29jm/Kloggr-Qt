import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Item {
	signal pauseClicked
	signal mainMenuClicked
	signal playClicked

	Canvas {
		id: canvas
		anchors.top: parent.top
		anchors.bottom: pauseBtn.top
		anchors.topMargin: 5
		anchors.leftMargin: 5
		anchors.rightMargin: 5
		anchors.bottomMargin: 5
	}

	PauseButton {
		id: pauseBtn

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.leftMargin: 5
		anchors.rightMargin: 5
		anchors.bottomMargin: 5

		onClicked: pauseClicked()
	}
}
