import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Rectangle {
    id: root
    width: 180
    height: 180
    radius: height / 2

    // API
    property bool enabled: true
    signal emergencyClicked

    color: root.enabled ? "#D32F2F" : "#BDBDBD"
    opacity: root.enabled ? 1.0 : 0.7

    Text {
        anchors.centerIn: parent
        text: "STOP"
        color: "#ffffff"
        font.pixelSize: 30
        font.bold: true
        font.letterSpacing: 0.8
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        onClicked: {
            root.emergencyClicked();
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: 80
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: 120
        }
    }
}
