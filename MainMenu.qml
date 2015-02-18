import QtQuick 2.3

Rectangle {
	color: "#4dd0e1"

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
		image: "assets/play-circle.svg"
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
		image: "assets/settings.svg"
		angle: 120
		width: parent.height/8
		imageWidth: settingsBtn.width/2

		anchors.left: parent.left
		anchors.leftMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

		onClicked: settingsClicked()
	}

	RoundButton {
		id: infoBtn
		image: "assets/info.svg"
		angle: 360
		width: parent.height/8
		imageWidth: infoBtn.width/2

		anchors.right: parent.right
		anchors.rightMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

		onClicked: infoClicked()
	}
}
