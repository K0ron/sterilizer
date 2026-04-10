import QtQuick
import QtQuick.Controls
import "components"

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: "Sterilizer"
    color: '#e7e7e7'

    readonly property int stateIdle: 0
    readonly property int stateHeating: 1
    readonly property int stateHold: 2
    readonly property int stateFinished: 3
    readonly property int stateError: 4
    readonly property int statePaused: 5

    property int selectedTemp: 0
    property int selectedSeconds: 60

    Rectangle {
        id: background
        // anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        width: 1150
        height: 150
        radius: 12
        color: "#ffffff"
        y: 100
        z: -1

        Row {
            width: background.width
            height: background.height
            anchors.left: parent.left
            anchors.leftMargin: 20

            spacing: 150

            TimeInlinePicker {
                id: timePicker
                width: 640
                height: background.height
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
                    width: parent.width
                    height: background.height

                    selectedTemperature: selectedTemp
                    currentTemperature: sterilizer.temperature
                    showCurrentTemperatureBadge: sterilizer.state === stateHeating || sterilizer.state === stateHold || sterilizer.state === statePaused

                    onChanged: function (t) {
                        selectedTemp = t;
                    }

                    onCommitted: function (t) {
                        selectedTemp = t;
                    }
                }

                HeatingIndicator {
                    anchors.top: temperaturePicker.bottom
                    anchors.topMargin: 20
                    active: sterilizer.state === stateHeating
                    temperature: sterilizer.temperature
                    targetTemperature: selectedTemp
                    visible: sterilizer.state === stateHeating || sterilizer.state === stateHold || sterilizer.state === statePaused
                }
            }
        }
    }

    Item {
        width: 900
        height: 240
        anchors.horizontalCenter: parent.horizontalCenter
        y: 400

        EmergencyButton {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            enabled: sterilizer.state === stateHeating || sterilizer.state === stateHold || sterilizer.state === statePaused

            onEmergencyClicked: {
                sterilizer.emergencyStop();
            }
        }

        StartButton {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: sterilizer.state === stateHeating || sterilizer.state === stateHold || selectedTemp >= temperaturePicker.minTemperature
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
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            enabled: sterilizer.state === statePaused || sterilizer.state === stateFinished || sterilizer.state === stateError
            onResetClicked: {
                sterilizer.reset();
                selectedTemp = 0;
                temperaturePicker.resetSelection();
            }
        }
    }
}
