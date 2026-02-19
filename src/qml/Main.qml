import QtQuick
import QtQuick.Controls
import "components"

ApplicationWindow {
    visible: true
    width: 700
    height: 480
    title: "Sterilizer"
    color: '#e7e7e7'

    Rectangle {
        id: background
        // anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        width: 650
        height: 100
        radius: 12
        color: "#ffffff"
        y: 100
        z: -1

        Row {
            width: background.width
            height: background.height
            anchors.left: parent.left
            anchors.leftMargin: 20

            spacing: 10

            TimeInlinePicker {
                width: 440
                height: 100
                totalSeconds: (1 * 3600) + (29 * 60)
                onCommitted: s => console.log("Committed:", s)
            }

            TemperaturePicker {
                width: 200
                height: 100
            }
        }
    }

    StartButton {
        y: 250
        anchors.horizontalCenter: parent.horizontalCenter
        enabled: true

        onClicked: {
            console.log("START pressed");
        }
    }

    property bool running: false
    property bool errorState: false

    StopResetButton {
        x: 500
        y: 300

        mode: errorState ? "reset" : (running ? "stop" : "reset")
        enabled: running || errorState

        onStopClicked: {
            console.log("STOP");
            running: false;
        }
        onResetClicked: {
            console.log("RESET");
            errorState = false;
        }
    }
}
