import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Rectangle {
    id: root
    width: 120
    height: 64
    radius: height / 2

    // API
    property bool enabled: true
    signal resetClicked

    color: root.enabled ? "#111111" : "#BDBDBD"
    opacity: root.enabled ? 1.0 : 0.7

    Text {
        anchors.centerIn: parent
        text: "RESET"
        color: "#ffffff"
        font.pixelSize: 18
        font.bold: true
        font.letterSpacing: 0.8
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        onClicked: {
            root.resetClicked();
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
