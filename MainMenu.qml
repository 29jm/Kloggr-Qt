import QtQuick 2.0


Rectangle {
	color: "#3498db"

	signal playClicked
	signal settingsClicked

	PlayButton {
		id: playBtn
		color: mainmenu.color
		anchors.horizontalCenter: mainmenu.horizontalCenter
		anchors.top: mainmenu.top
		anchors.topMargin: 30

		onButtonClicked: playClicked()
	}

	ImageButton {
		id: optionBtn
		image.source: "option.png"
		color: mainmenu.color

		anchors.left: mainmenu.left
		anchors.leftMargin: 10
		anchors.bottom: mainmenu.bottom
		anchors.bottomMargin: 10

		onButtonClicked: settingsClicked()
	}
}
