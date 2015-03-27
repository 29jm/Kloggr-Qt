import QtGraphicalEffects 1.0
import QtQuick 2.3

Rectangle {
	id: info
	color: "#4dd0e1"

	signal mainMenuClicked

	Component.onCompleted: {
		info.forceActiveFocus();
	}

	ClickButton {
		id: back
		color: "#00bcd4"
		width: parent.height/6
		height: width
		z: 1

		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height/10
		anchors.left: social_container.left

		onClicked:  mainMenuClicked()

		Image {
			source: "assets/exit.svg"
			smooth: true
			fillMode: Image.PreserveAspectFit
			anchors.centerIn: parent
			width: parent.height/2
		}
	}

	Image {
		id: devs
		source: "assets/devs.png"
		smooth: true
		height: back.height
		fillMode: Image.PreserveAspectFit
		anchors.bottom: back.bottom
		anchors.left: back.right
		z: 2
	}

	FontLoader {
		id: roboto;
		source: "assets/ttf"
	}

	Text {
		color: "white"
		text: qsTr("this game is open-source!")
		font.pixelSize: devs.height/4
		smooth: true
		font.family: roboto.name
		anchors.bottom: parent.bottom
		anchors.bottomMargin: this.height/2
		anchors.horizontalCenter: parent.horizontalCenter
		z: 4
	}

	Rectangle {
		color: "#27ae60"
		width: parent.width
		height: parent.height/6
		anchors.bottom: parent.bottom
	}

	Rectangle {
		id: sun
		width: parent.width/2
		height: width
		radius: width/2
		color: "#ffeb3b"

		anchors.left: parent.left
		anchors.top: parent.top
		anchors.topMargin: -width/2
		anchors.rightMargin: -width/2
		anchors.leftMargin: -width/2

		states: [
			State {
				name: ""
				AnchorChanges {
					target: sun
					anchors.left: info.left
					anchors.right: undefined
				}
				onCompleted: sun.state = "right"
			},
			State {
				name: "right"
				AnchorChanges {
					target: sun
					anchors.right: info.right
					anchors.left: undefined
				}
				onCompleted: sun.state = ""
			}
		]
		transitions: Transition {
			AnchorAnimation {duration: 20000;}
		}
		Component.onCompleted: sun.state = "right"
	}

	Grid {
		id: social_container
		columns: 2
		rows: 2
		spacing: parent.width/16
		anchors.centerIn: parent
		z: 3

		Rectangle {
			width: google.width
			height: width
			color: info.color
			radius: width/2

			MouseArea {
				anchors.fill: parent
				onClicked: {
					Qt.openUrlExternally("https://plus.google.com/u/0/114056733775000645504/posts");
				}
			}

			Image {
				id: google
				width: info.height/8
				height: width
				source: "assets/gplus.png"
				fillMode: Image.PreserveAspectFit
			}
		}

		Rectangle {
			width: github.width
			height: width
			color: info.color
			radius: width/2

			MouseArea {
				anchors.fill: parent
				onClicked: {
					Qt.openUrlExternally("https://github.com/29jm/Kloggr-Qt");
				}
			}

			Image {
				id: github
				width: info.height/8
				height: width
				source: "assets/github.png"
				fillMode: Image.PreserveAspectFit
			}
		}

		Rectangle {
			width: facebook.width
			height: width
			color: info.color
			radius: width/2

			MouseArea {
				anchors.fill: parent
				onClicked: {
					Qt.openUrlExternally("https://www.facebook.com/kloggr");
				}
			}

			Image {
				id: facebook
				width: info.height/8
				height: width
				source: "assets/facebook.png"
				fillMode: Image.PreserveAspectFit
			}
		}

		Rectangle {
			width: twitter.width
			height: width
			color: info.color
			radius: width/2

			MouseArea {
				anchors.fill: parent
				onClicked: {
					Qt.openUrlExternally("https://twitter.com/Creahoof");
				}
			}

			Image {
				id: twitter
				width: info.height/8
				height: width
				source: "assets/twitter.png"
				fillMode: Image.PreserveAspectFit
			}
		}
	}

	DropShadow {
		anchors.fill: social_container
		horizontalOffset: (google.x-sun.x+sun.width/2)/(0.10*google.width)
		verticalOffset: (google.y-sun.y+sun.width/2)/(0.10*google.width)
		samples: 16
		color: "#00bcd4"
		source: social_container
	}

	Keys.onReleased: {
		if (event.key === Qt.Key_Back) {
			mainMenuClicked();
			event.accepted = true;
		}
	}
}
