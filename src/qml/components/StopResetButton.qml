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
    property string mode: "stop"
    signal stopClicked
    signal resetClicked

    // stryle
    readonly property bool isStop: root.mode === "stop"

    color: !root.enabled ? "#BDBDBD" : (isStop ? "#E53935" : "#111111")
    opacity: root.enabled ? 1.0 : 0.7

    Text {
        anchors.centerIn: parent
        text: isStop ? "STOP" : "RESET"
        color: "#ffffff"
        font.pixelSize: 18
        font.bold: true
        font.letterSpacing: 0.8
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        onClicked: {
            if (root.isStop)
                root.stopClicked();
            else
                root.resetClicked();
        }

        onPressed: root.scale = 0.98
        onReleased: root.scale = 1.0
        onCanceled: root.scale = 1.0
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
