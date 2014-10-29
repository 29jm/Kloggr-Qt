import QtQuick 2.3

Rectangle {
	color: "#00bcd4"

	signal playClicked
	signal settingsClicked
	signal infoClicked

	FontLoader {
		id: roboto;
		source: "assets/roboto/Roboto-Light.ttf"
	}

	Image {
		id: logo
		fillMode: Image.PreserveAspectFit
		smooth: true
		source: "assets/logo.png"

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top
		anchors.topMargin: 20
		anchors.left: parent.left
		anchors.right: parent.right

	}

	//play button
	Buttons {
		imgSource: "assets/play.png"
		imgId: "playImg"
		degree: 360
		rectWidth: parent.height/4
		imgWidth: parent.height/4
		color: "#f1c40f"

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter

		onBtnClicked: playClicked()
	}

	// settings button
	Buttons {
		imgSource: "assets/settings.png"
		imgId: "settingsImg"
		degree: 120
		rectWidth: parent.height/8
		imgWidth: 50

		anchors.left: parent.left
		anchors.leftMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

		onBtnClicked: settingsClicked()
	}

	//info button
	Buttons {
		imgSource: "assets/info.png"
		imgId: "infoImg"
		degree: 360
		rectWidth: parent.height/8
		imgWidth: 50

		anchors.right: parent.right
		anchors.rightMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

		onBtnClicked: infoClicked()
	}
}
