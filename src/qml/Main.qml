import QtQuick
import QtQuick.Controls
import "components"

ApplicationWindow {
    visible: true
    width: 700
    height: 480
    title: "Sterilizer"
    color: '#e7e7e7'

    readonly property int stateIdle: 0
    readonly property int stateHeating: 1
    readonly property int stateHold: 2
    readonly property int stateFinished: 3
    readonly property int stateError: 4
    readonly property int statePaused: 5

    property int selectedTemp: 40
    property int selectedSeconds: 60

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
                id: timePicker
                width: 440
                height: 100
                totalSeconds: (sterilizer.state === stateHeating || sterilizer.state === stateHold || sterilizer.state === stateFinished || sterilizer.state === statePaused) ? sterilizer.remainingTime : selectedSeconds
                onCommitted: function (s) {
                    selectedSeconds = s;
                }
            }

            Item {
                width: 200
                height: 128

                TemperaturePicker {
                    id: temperaturePicker
                    width: 200
                    height: 100

                    selectedTemperature: selectedTemp
                    currentTemperature: sterilizer.temperature

                    onCommitted: function (t) {
                        selectedTemp = t;
                    }
                }

                HeatingIndicator {
                    anchors.top: temperaturePicker.bottom
                    anchors.topMargin: 8
                    anchors.horizontalCenter: temperaturePicker.horizontalCenter
                    active: sterilizer.state === stateHeating
                    temperature: sterilizer.temperature
                    visible: sterilizer.state === stateHeating
                }
            }
        }
    }

    Item {
        width: 600
        height: 180
        anchors.horizontalCenter: parent.horizontalCenter
        y: 250

        EmergencyButton {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            enabled: sterilizer.state === stateHeating || sterilizer.state === stateHold || sterilizer.state === statePaused

            onEmergencyClicked: {
                sterilizer.emergencyStop();
            }
        }

        StartButton {
            //y: 250
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: true
            running: sterilizer.state === stateHeating || sterilizer.state === stateHold

            onClicked: {
                if (sterilizer.state === stateHeating || sterilizer.state === stateHold) {
                    sterilizer.pause();
                } else {
                    if (sterilizer.state === stateIdle || sterilizer.state === stateFinished) {
                        sterilizer.configure(selectedTemp, selectedSeconds);
                    }

                    sterilizer.start();
                }
            }
        }

        ResetButton {
            // x: 500
            // y: 300
            anchors.right: parent.right

            anchors.verticalCenter: parent.verticalCenter

            enabled: sterilizer.state === statePaused || sterilizer.state === stateFinished || sterilizer.state === stateError

            onResetClicked: {
                sterilizer.reset();
            }
        }
    }
}
