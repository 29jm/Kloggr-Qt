import QtQuick 2.3

Rectangle {
    color: "#3498db"

    signal playClicked
    signal settingsClicked

    Rectangle {
        id: playBtn
        anchors.horizontalCenter: mainmenu.horizontalCenter
        anchors.verticalCenter: mainmenu.verticalCenter
        width: parent.width/4; height: width
        color: mainmenu.color

        MouseArea {
            id: btnArea
            hoverEnabled: true
            anchors.fill: parent

            onClicked: playClicked()
        }

        Image {
            id: img
            fillMode: Image.PreserveAspectFit
            width: parent.width
            height: parent.height
            source: "play.png"
        }
        states: State {
            name: "rotated"; when: btnArea.containsMouse == true
            PropertyChanges {
                target: img; rotation: 360
            }
        }

        transitions: Transition {
            from: ""; to: "rotated"
            reversible: true
            NumberAnimation { property: "rotation"; duration: 500; easing.type: Easing.InOutQuad }
        }
    }

    ImageButton {
        id: optionBtn
        image.source: "option.png"
        color: mainmenu.color

        anchors.left: mainmenu.left
        anchors.leftMargin: mainmenu.width/3-this.width
        anchors.bottom: mainmenu.bottom
        anchors.bottomMargin: mainmenu.height/3-this.width

        width: 100
        height: 100

        onButtonClicked: settingsClicked()
    }
    ImageButton {
        id: infoBtn
        image.source: "option.png"
        color: mainmenu.color

        anchors.right: mainmenu.right
        anchors.rightMargin: mainmenu.width/3-this.width
        anchors.bottom: mainmenu.bottom
        anchors.bottomMargin: mainmenu.height/3-this.width

        width: 100
        height: 100

        onButtonClicked: settingsClicked()
    }
}
