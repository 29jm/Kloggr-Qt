import QtQuick 2.3
import QtQuick.Controls 1.2
import QtMultimedia 5.0
import Qt.labs.settings 1.0
import QtQuick.Particles 2.0

Rectangle {
	id: gameArea
	color: "#34495e"

	property bool soundOn: true

	signal mainMenuClicked

	Kloggr {
		id: kloggr

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom

		onDead: {
			deadSound.play();
			getHighscore();
			parent.state = "Dead";
		}

		onScoreChanged: {
			if (new_score !== 0) {
				oneUpSound.play();
			}
		}

		onNewHighscore: {
			highscoreSound.play();
			confettis.running = true;
			emitter.enabled = true;
		}
	}

	RoundButton {
		id: restartBtn
		image: "assets/reload.svg"
		angle: 360
		width: parent.height/8
		imageWidth: restartBtn.height/2
		visible: false
		opacity: 0

		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.topMargin: -this.width/2
		anchors.rightMargin: score_container.width*0.25-this.width/2
		z: 10

		onClicked: {
			kloggr.restart();
			parent.state = ""
		}
	}

	RoundButton {
		id: exitBtn
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
		id: pauseBtn
		height: 6*kloggr.pixelDensity
		width: height
		color: "#00bcd4"
		opacity: 0.8

		anchors.left: parent.left
		anchors.bottom: parent.bottom

		Image {
			id: pauseImg
			sourceSize.width: parent.width*0.90
			fillMode: Image.PreserveAspectFit
			smooth: true
			anchors.centerIn: parent
			source: "assets/pause.svg"
		}

		MouseArea {
			anchors.fill: parent
			onClicked: {
				parent.parent.state = (parent.parent.state == "" ? "Paused" : "");
				if (parent.parent.state == "Paused") {
					kloggr.pause();
				}
				else {
					kloggr.play();
				}
			}
		}
	}

	Rectangle {
		id: pause_container
		width: parent.width*0.7
		height: parent.height/4
		color: "#4dd0e1"
		anchors.centerIn: parent
		visible: false
		opacity: 0
		Text {
			color: "white"
			text: "Pause"
			font.pixelSize: 40
			smooth: true
			font.family: roboto.name
			anchors.centerIn: parent
		}
	}

	Rectangle {
		id: score_container
		width: parent.width*0.7
		height: parent.height/4
		color: "#4dd0e1"
		anchors.centerIn: parent
		visible: false
		opacity: 0

		Item {
			width: parent.width
			height: parent.height*0.65
			anchors.top: parent.top
			anchors.left: parent.left

			Text {
				id: current_points
				color: "white"
				text: "0"
				font.pixelSize: parent.height*0.60
				smooth: true
				font.family: roboto.name
				font.bold: true
				anchors.centerIn: parent
			}
		}

		Item {
			id: currentScore_container
			width: parent.width*0.25
			height: parent.height*0.35
			anchors.bottom: parent.bottom
			anchors.left: parent.left

			Text {
				id: current_score
				color: "white"
				text: "0"
				font.pixelSize: parent.height*0.50
				smooth: true
				font.family: roboto.name
				font.bold: true
				anchors.centerIn: parent
			}
		}

		Item {
			width: parent.width*0.25
			height: parent.height*0.35
			anchors.bottom: parent.bottom
			anchors.left: currentScore_container.right

			Text {
				id: current_time
				color: "white"
				text: "0"
				font.pixelSize: parent.height*0.50
				smooth: true
				font.family: roboto.name
				font.bold: true
				anchors.centerIn: parent
			}
		}

		onVisibleChanged: {
			if (visible) {
				current_points.text = kloggr.getPoints() + "pts";
				current_score.text = kloggr.getScore() + "";
				current_time.text = kloggr.getTime() + "s";
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
			PropertyChanges { target: pauseImg; source: "assets/play.svg"}
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
			PropertyChanges { target: pauseBtn; visible: false }
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
