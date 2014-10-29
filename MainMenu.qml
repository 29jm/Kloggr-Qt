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

		anchors.top: parent.top
		anchors.topMargin: 20
		anchors.left: parent.left
		anchors.right: parent.right
	}

	//play button
	RoundButton {
		id: playBtn
		source: "assets/play.png"
		angle: 360
		width: parent.height/4
		color: "#f1c40f"

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter

		onClicked: playClicked()
	}

	// settings button
	RoundButton {
		id: settingsBtn
		source: "assets/settings.png"
		angle: 120
		width: parent.height/8

		anchors.left: parent.left
		anchors.leftMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

		onClicked: settingsClicked()
	}

	//info button
	RoundButton {
		source: "assets/info.png"
		id: infoBtn
		angle: 360
		width: parent.height/8

		anchors.right: parent.right
		anchors.rightMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

		onClicked: infoClicked()
	}
}
