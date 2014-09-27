import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Button {
	text: "Pause"
	style: ButtonStyle {
		background: Rectangle {
			implicitWidth: 55
			implicitHeight: 25
			border.width: control.activeFocus ? 2 : 1
			border.color: "black"
			radius: 4
			gradient: Gradient {
				GradientStop { position: 0; color: control.pressed ? "#ccc" : "#eee" }
				GradientStop { position: 1; color: control.pressed ? "#aaa" : "#ccc" }
			}
		}
	}
}
