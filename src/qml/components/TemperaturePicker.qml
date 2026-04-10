import QtQuick
import QtQuick.Controls

Item {
    id: root

    // API
    property int maxTemperature: 210
    property int minTemperature: 30
    property int temperatureStep: 1
    property int selectedTemperature: 0
    property int currentTemperature: 99
    property bool showCurrentTemperatureBadge: false
    readonly property bool hasValidSelection: selectedTemperature >= minTemperature && selectedTemperature <= maxTemperature
    readonly property string displayTemperatureText: hasValidSelection ? selectedTemperature.toString() : "--"

    // Edition mode
    property bool editing: false

    signal changed(int selectedTemperature)
    signal committed(int selectedTemperature)

    function setSelectedTemperature(t) {
        if (t < minTemperature)
            t = minTemperature;
        if (t > maxTemperature)
            t = maxTemperature;
        if (t === selectedTemperature)
            return;
        selectedTemperature = t;
        changed(t);
    }

    function commitSelection() {
        if (!editing)
            return;
        editing = false;
        commitTimer.stop();
        committed(selectedTemperature);
    }

    function resetSelection() {
        commitTimer.stop();
        editing = false;
        selectedTemperature = 0;
    }

    Timer {
        id: commitTimer
        interval: 1000
        repeat: false
        onTriggered: root.commitSelection()
    }

    Row {
        id: displayRow
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: temperatureBox
            width: 200
            height: 110
            radius: 16

            Tumbler {
                id: temperatureWheel
                visible: root.editing
                wrap: false
                width: parent.width
                height: 300
                x: 0
                y: parent.height / 2 - height / 2
                model: Math.floor((root.maxTemperature - root.minTemperature) / root.temperatureStep) + 1
                currentIndex: root.hasValidSelection ? Math.floor((root.selectedTemperature - root.minTemperature) / root.temperatureStep) : 0

                onCurrentIndexChanged: {
                    if (!root.editing)
                        return;
                    const t = root.minTemperature + currentIndex * root.temperatureStep;
                    root.setSelectedTemperature(t);
                    commitTimer.restart();
                }

                delegate: Item {
                    width: temperatureWheel.width
                    height: 44

                    readonly property int v: root.minTemperature + index * root.temperatureStep
                    readonly property bool current: index === temperatureWheel.currentIndex

                    Text {
                        anchors.centerIn: parent
                        text: v
                        font.pixelSize: parent.current ? 60 : 30
                        font.bold: parent.current
                        color: "#111"
                        opacity: parent.current ? 1.0 : 0.35
                    }
                }

                //Fade TOP
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: 40
                    z: 2
                    visible: root.editing

                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: "#e7e7e7"
                        }
                        GradientStop {
                            position: 1.0
                            color: "transparent"
                        }
                    }
                }

                //Fade BOTTOM
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 40
                    z: 2
                    visible: root.editing

                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: "transparent"
                        }
                        GradientStop {
                            position: 1.0
                            color: "#e7e7e7"
                        }
                    }
                }
            }

            Rectangle {
                visible: root.editing
                anchors.centerIn: parent
                width: parent.width
                height: temperatureBox.height
                radius: 12
                color: "#000000"
                opacity: 0.04
            }

            Text {
                opacity: !root.editing
                anchors.centerIn: parent
                text: root.displayTemperatureText
                color: "#111"
                font.pixelSize: 60
                font.bold: true
            }

            TapHandler {
                enabled: !root.editing
                onTapped: {
                    commitTimer.stop();
                    root.editing = true;
                }
            }

            Text {
                visible: !root.editing
                anchors.centerIn: parent
                text: root.displayTemperatureText
                font.pixelSize: 60
                font.bold: true
            }
        }

        Text {
            text: "°C"
            color: "#666"
            font.pixelSize: 30
            anchors.verticalCenter: temperatureBox.verticalCenter
        }
    }

    Rectangle {
        id: currentTemperatureBox
        visible: root.showCurrentTemperatureBadge
        width: root.currentTemperature >= 100 ? 120 : 100
        height: 60
        radius: 8
        color: "#ccc"
        y: 200
        anchors.horizontalCenter: displayRow.horizontalCenter

        Row {
            spacing: 4
            anchors.centerIn: parent

            Text {
                text: root.currentTemperature === 0 ? "--" : Math.round(root.currentTemperature)
                font.pixelSize: 30
                font.bold: false
            }

            Text {
                text: "°C"
                font.pixelSize: 20
                font.bold: false
            }
        }
    }
}
