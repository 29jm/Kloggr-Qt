import QtQuick 2.3
import QtQuick.Controls 1.2
import QtMultimedia 5.0
import Qt.labs.settings 1.0
import QtQuick.Particles 2.0
import QtQuick.Window 2.0

Rectangle {
	id: gameArea
	color: "#34495e"

	property bool soundOn: true

	signal mainMenuClicked

	Component.onCompleted: {
		kloggr.forceActiveFocus();
	}

	Kloggr {
		id: kloggr

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom

		onDead: {
			deadSound.play();
			gameArea.state = "Dead";
		}

		onTargetReached: {
			oneUpSound.play();
		}

		onNewHighscore: {
			highscoreSound.play();
			confettis.running = true;
			emitter.enabled = true;
		}

		onScoreChanged: {
			score_text.text = qsTr("%1").arg(kloggr.score);
		}

		Keys.onReleased: {
			if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape) {
				event.accepted = true;

				if (gameArea.state === "") {
					gameArea.state = "Paused";
					kloggr.pause();
				} else if (gameArea.state === "Paused") {
					gameArea.state = "";
					kloggr.play();
				} else if (gameArea.state === "Dead") {
					mainMenuClicked();
				}
			}
		}
	}

	Item {
		width: 6*kloggr.pixelDensity
		height: width
		anchors.top: parent.top
		anchors.left: parent.left
		Text {
			id: score_text
			color: "white"
			text: qsTr("%1").arg(kloggr.score)
			anchors.centerIn: parent
		}
	}

	RoundButton {
		id: restartBtn
		color: "#00bcd4"
		image: "assets/reload.svg"
		angle: 360
		width: parent.height/8
		imageWidth: restartBtn.height/2
		visible: false
		opacity: 0

		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.topMargin: -this.width/2
		anchors.rightMargin: score_container.width*0.25-this.width
		z: 10

		onClicked: {
			kloggr.restart();
			parent.state = ""
		}
	}

	RoundButton {
		id: exitBtn
		color: "#00bcd4"
		image: "assets/exit.svg"
		angle: 180
		width: parent.height/12
		imageWidth: exitBtn.height/2
		visible: false
		opacity: 0

		anchors.top: restartBtn.top
		anchors.topMargin: restartBtn.height+5
		anchors.horizontalCenter: restartBtn.horizontalCenter

		onClicked: mainMenuClicked()
	}

	Rectangle {
		id: pause_container
		width: parent.width*0.7
		height: parent.height/4
		color: "#00bcd4"
		anchors.centerIn: parent
		visible: false
		opacity: 0
		Item {
			id: playContainer
			height: parent.height*0.70
			width: parent.width
			anchors.left: parent.left
			anchors.top: parent.top
			Image {
				id: playbutton
				source: "assets/play.svg"
				sourceSize.height: parent.height*0.60
				fillMode: Image.PreserveAspectFit
				anchors.centerIn: parent

				MouseArea {
					anchors.fill: parent
					onClicked: {
						gameArea.state = "";
						kloggr.play();
					}
				}
			}
		}

		Rectangle {
			width: parent.width
			anchors.top: playContainer.bottom
			anchors.bottom: parent.bottom
			anchors.left: parent.left
			Text {
				color: "black"
				text: "Pause"
				font.pixelSize: parent.height*0.60
				smooth: true
				font.family: roboto.name
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: parent.width*0.05
			}
		}
	}

	Rectangle {
		id: score_container
		width: parent.width*0.8
		height: parent.height/2.5
		color: "#00bcd4"
		anchors.centerIn: parent
		visible: false
		opacity: 0

		Rectangle {
			id: current_points_container
			color: "#00bcd4"
			width: parent.width
			height: parent.height*0.60
			anchors.top: parent.top
			anchors.left: parent.left

			Text {
				id: current_points
				color: "white"
				text: "0"
				font.pixelSize: parent.height*0.45
				smooth: true
				font.family: roboto.name
				font.bold: true
				anchors.top: parent.top
				anchors.topMargin: parent.height*0.10
				anchors.horizontalCenter: parent.horizontalCenter
			}

			Item {
				id: highscore_container
				width: crown.width+highscore.width
				height: parent.height*0.20
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: current_points.bottom
				anchors.topMargin: parent.height*0.10
				Image {
					id: crown
					source: "assets/crown.svg"
					sourceSize.height: parent.height
					fillMode: Image.PreserveAspectFit
				}
				Text {
					id: highscore
					color: "white"
					text: "0"
					font.pixelSize: parent.height*0.90
					smooth: true
					font.family: roboto.name
					font.bold: true
					anchors.left: crown.right
					anchors.leftMargin: 3
					anchors.verticalCenter: parent.verticalCenter
				}
			}
		}

		Rectangle {
			id: description
			width: parent.width
			height: parent.height*0.20
			anchors.top: current_points_container.bottom
			anchors.left: parent.left
			Text {
				id: current_score
				color: "black"
				text: "0"
				font.pixelSize: parent.height*0.30+parent.width*0.05
				smooth: true
				font.family: roboto.name
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: parent.width*0.05
			}
		}

		Rectangle {
			width: parent.width
			height: 1
			color: "lightgrey"
			anchors.top: description.bottom
			anchors.left: parent.left
			z: 10
		}

		Rectangle {
			width: parent.width
			height: parent.height*0.20
			anchors.top: description.bottom
			anchors.left: parent.left
			Text {
				color: "black"
				text: qsTr("Try Again!")
				font.pixelSize: parent.height*0.50
				smooth: true
				font.family: roboto.name
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: parent.width*0.05
			}
		}

		onVisibleChanged: {
			if (visible) {
				current_points.text = qsTr("%1pts").arg(kloggr.getPoints());
				current_score.text = qsTr("You scored %1 in %2s").arg(kloggr.getScore()).arg(kloggr.getTime());
				highscore.text = kloggr.highscore;
			}
		}

		FontLoader {
			id: roboto;
			source: "assets/ttf"
		}
	}

	onVisibleChanged: {
		if (visible) {
			kloggr.play();
		}
	}

	states: [
		State {
			name: "Paused"
			PropertyChanges { target: pause_container; visible: true; opacity: 1}
			PropertyChanges { target: restartBtn; visible: true; opacity: 1}
			AnchorChanges {
				target: restartBtn
				anchors.top: pause_container.bottom
				anchors.verticalCenter: undefined
				anchors.right: pause_container.right
				anchors.bottom: undefined
				anchors.left: undefined
			}
			PropertyChanges { target: exitBtn; visible: true; opacity: 1}
		},
		State {
			name: "Dead"
			PropertyChanges { target: score_container; visible: true; opacity: 1}
			PropertyChanges { target: restartBtn; visible: true; opacity: 1 }
			AnchorChanges {
				target: restartBtn
				anchors.top: score_container.bottom
				anchors.right: score_container.right
				anchors.bottom: undefined
				anchors.left: undefined
			}
			PropertyChanges { target: exitBtn; visible: true; opacity: 1}
		}
	]
	transitions: [
		Transition {
			from: ""; to: "Paused"
			AnchorAnimation {  duration: 500; easing.type: Easing.OutCirc }
			PropertyAnimation {property: "opacity";  duration: 1000; easing.type: Easing.OutCirc }
		},
		Transition {
			from: ""; to: "Dead"
			AnchorAnimation {  duration: 500; easing.type: Easing.OutCirc }
			PropertyAnimation {property: "opacity";  duration: 1000; easing.type: Easing.OutCirc }
		}
	]

	ParticleSystem {
		id: confettis
		running: false

		anchors.fill: parent

		Emitter {
			id: emitter
			enabled: false
			width: parent.width
			height: 0
			x: 0
			y: 0
			emitRate: 8
			lifeSpan: 4000
			lifeSpanVariation: 800
			size: 8
			endSize: -1 // constant
			velocity: PointDirection {
				x: 0
				y: 150
				xVariation: 10
			}
			onEnabledChanged: {
				confettis_timer.start();
			}
		}

		ItemParticle {
			delegate: particleDelegate
		}

		Wander {
			anchors.fill: parent
			affectedParameter: Wander.Velocity
			pace: 100
			xVariance: 100
			yVariance: 130
		}
	}

	Component {
		id: particleDelegate

		Rectangle {
			property var colors: ["#00BCD4","#FFEB3B", "#FF5722"]
			width: 9; height: 6
			color: colors[Math.round(Math.random()*2)]
		}
	}

	Timer {
		id: confettis_timer
		interval: 3000
		repeat: false
		running: false

		onTriggered: emitter.enabled = false;
	}

	SoundEffect {
		id: oneUpSound
		source: "qrc:/assets/woosh.wav"
		muted: !soundOn
	}

	SoundEffect {
		id: deadSound
		source: "qrc:/assets/gameover.wav"
		muted: !soundOn
	}

	SoundEffect {
		id: highscoreSound
		source: "qrc:/assets/highscore.wav"
		muted: !soundOn
	}

	Settings {
		id: settings
		property alias soundOn: gameArea.soundOn
	}
}
