import QtQuick 2.3

Rectangle {
	color: "#3498db"

	signal playClicked
	signal settingsClicked
	signal infosClicked

	Image {
		id: logo
		source: "assets/logo.png"
		fillMode: Image.PreserveAspectFit
		smooth: true
		width: parent.width/1.5

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top
		anchors.topMargin: 30
	}

	Rectangle {
		id: playBtn
		width: parent.height/4; height: width
		radius: width*0.5
		color: "#f1c40f"

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter

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

	// settings button
	Rectangle {
		id: optionBtn
		width: playBtn.width/2; height: width
		radius: width*0.5
		color: parent.color

		anchors.left: parent.left
		anchors.leftMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

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

	//info button
	Rectangle {
		id: infoBtn
		width: playBtn.width/2; height: width
		radius: width*0.5
		color: parent.color

		anchors.right: parent.right
		anchors.rightMargin: parent.width/3-this.width
		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/4-this.width

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
