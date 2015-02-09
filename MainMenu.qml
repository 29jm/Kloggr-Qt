import QtQuick 2.3

Rectangle {
	color: "#00bcd4"

	signal playClicked
	signal settingsClicked
	signal infoClicked

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

	RoundButton {
		id: playBtn
		image: "assets/play.png"
		angle: 360
		width: parent.height/4
		imageWidth: width
		color: "#f1c40f"

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter

		onClicked: playClicked()
	}

	RoundButton {
		id: settingsBtn
		image: "assets/settings.png"
		angle: 120
		width: parent.height/8
		imageWidth: 50

		anchors.left: parent.left
		anchors.leftMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

		onClicked: settingsClicked()
	}

	RoundButton {
		image: "assets/info.png"
		id: infoBtn
		angle: 360
		width: parent.height/8
		imageWidth: 50

		anchors.right: parent.right
		anchors.rightMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

		onClicked: infoClicked()
	}
}
