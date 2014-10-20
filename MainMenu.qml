import QtQuick 2.3

Rectangle {
	color: "#3498db"

	signal playClicked
	signal settingsClicked

	Image {
		id: logo
		source: "assets/logo.png"
		fillMode: Image.PreserveAspectFit
		smooth: true
		width: parent.width

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.leftMargin: 10
		anchors.rightMargin: 10

	}

	Rectangle {
		id: playBtn
		width: parent.width/4; height: width
		radius: width*0.5
		color: "#f1c40f"

		anchors.horizontalCenter: mainmenu.horizontalCenter
		anchors.verticalCenter: mainmenu.verticalCenter

		MouseArea {
			id: playArea
			hoverEnabled: true
			anchors.fill: parent

			onClicked: playClicked()
		}

		Image {
			id: playImg
			fillMode: Image.PreserveAspectFit
			smooth: true
			width: parent.width
			height: parent.height
			source: "assets/play.png"
		}
		states: State {
			name: "rotated"; when: playArea.containsMouse == true
			PropertyChanges {
				target: playImg; rotation: 360
			}
		}

		transitions: Transition {
			from: ""; to: "rotated"
			reversible: true
			NumberAnimation { property: "rotation"; duration: 500; easing.type: Easing.InOutQuad }
		}
	}

	Rectangle {
		id: optionBtn
		width: parent.width/6; height: width
		radius: width*0.5
		color: mainmenu.color

		anchors.left: mainmenu.left
		anchors.leftMargin: mainmenu.width/3-this.width
		anchors.bottom: mainmenu.bottom
		anchors.bottomMargin: mainmenu.height/4-this.width

		MouseArea {
			id: settingsArea
			hoverEnabled: true
			anchors.fill: parent

			onClicked: settingsClicked()
		}

		Image {
			id: settingsImg
			fillMode: Image.PreserveAspectFit
			smooth: true
			width: parent.width
			height: parent.height
			source: "assets/settings.png"
		}
		states: State {
			name: "rotated"; when: settingsArea.containsMouse == true
			PropertyChanges {
				target: settingsImg; rotation: 120
			}
		}

		transitions: Transition {
			from: ""; to: "rotated"
			reversible: true
			NumberAnimation { property: "rotation"; duration: 500; easing.type: Easing.InOutQuad }
		}
	}

	Rectangle {
		id: infoBtn
		width: parent.width/6; height: width
		radius: width*0.5
		color: mainmenu.color

		anchors.right: mainmenu.right
		anchors.rightMargin: mainmenu.width/3-this.width
		anchors.bottom: mainmenu.bottom
		anchors.bottomMargin: mainmenu.height/4-this.width

		MouseArea {
			id: infoArea
			hoverEnabled: true
			anchors.fill: parent

			onClicked: settingsClicked()
		}

		Image {
			id: infoImg
			fillMode: Image.PreserveAspectFit
			smooth: true
			width: parent.width
			height: parent.height
			source: "assets/info.png"
		}
		states: State {
			name: "rotated"; when: infoArea.containsMouse == true
			PropertyChanges {
				target: infoImg; rotation: 360
			}
		}

		transitions: Transition {
			from: ""; to: "rotated"
			reversible: true
			NumberAnimation { property: "rotation"; duration: 500; easing.type: Easing.InOutQuad }
		}
	}
}
