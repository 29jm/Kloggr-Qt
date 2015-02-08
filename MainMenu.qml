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
		source: "assets/play.png"
		angle: 360
		btnWidth: parent.height/4
		imgWidth: btnWidth
		color: "#f1c40f"

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter

		onClicked: playClicked()
	}

	RoundButton {
		id: settingsBtn
		source: "assets/settings.png"
		angle: 120
		btnWidth: parent.height/8
		imgWidth: 50

		anchors.left: parent.left
		anchors.leftMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

		onClicked: settingsClicked()
	}

	RoundButton {
		source: "assets/info.png"
		id: infoBtn
		angle: 360
		btnWidth: parent.height/8
		imgWidth: 50

		anchors.right: parent.right
		anchors.rightMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

		onClicked: infoClicked()
	}
}
