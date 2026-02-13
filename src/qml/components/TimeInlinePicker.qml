import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 360
    height: 96

    // API
    property int totalSeconds: 60
    property int maxHours: 12
    property int maxMinutes: 59
    property int minuteStep: 1
    property int hoursStep: 1
    property int maxSeconds: 59

    // Edition mode
    property bool editing: false
    property int editingPart: 0

    signal changed(int totalSeconds)
    signal committed(int totalSeconds)

    function two(n) {
        return (n < 10 ? "0" : "") + n;
    }
    function hours() {
        return Math.floor(totalSeconds / 3600);
    }
    function minutes() {
        return Math.floor((totalSeconds % 3600) / 60);
    }
    function seconds() {
        return totalSeconds % 60;
    }

    function setHours(h) {
        const m = minutes();
        totalSeconds = (h * 3600) + (m * 60) + seconds();
        changed(totalSeconds);
    }

    function setMinutes(m) {
        const h = hours();
        totalSeconds = (h * 3600) + (m * 60) + seconds();
        changed(totalSeconds);
    }

    // CHANGED: affichage devant (cases), toujours visible
    Row {
        id: displayRow
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 14

        // hours case
        Row {

            Rectangle {
                id: hoursBox
                width: 110
                height: 64
                radius: 12
                color: "#ffffff"
                clip: false

                Tumbler {
                    id: hoursWheel
                    visible: root.editing && root.editingPart === 0
                    width: hoursBox.width
                    height: 200
                    x: 0
                    y: parent.height / 2 - height / 2

                    model: root.maxHours + 1
                    currentIndex: root.hours()

                    onCurrentIndexChanged: {
                        if (!root.editing)
                            return;
                        root.setHours(currentIndex);
                    }

                    delegate: Item {
                        width: hoursWheel.width
                        height: 44

                        readonly property int v: modelData * root.hoursStep
                        readonly property bool current: index === hoursWheel.currentIndex

                        Text {
                            anchors.centerIn: parent
                            text: v < 10 ? ("0" + v) : ("" + v)
                            font.pixelSize: parent.current ? 42 : 22
                            font.bold: parent.current
                            color: "#111"
                            opacity: parent.current ? 1.0 : 0.35
                        }
                    }

                    // Fade TOP
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 40
                        z: 2
                        visible: root.editing && root.editingPart === 0

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

                    // Fade BOTTOM
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 40
                        z: 2
                        visible: root.editing && root.editingPart === 0

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
                    visible: root.editing && root.editingPart === 0
                    radius: 12
                    color: "#000000"
                    opacity: 0.04

                    width: (root.editingPart === 0) ? hoursBox.width : minutesBox.width
                    height: (root.editingPart === 0) ? hoursBox.height : minutesBox.height

                    x: (root.editingPart === 0) ? hoursBox.x : minutesBox.x
                    y: (root.editingPart === 0) ? hoursBox.y : minutesBox.y
                }

                Text {
                    opacity: (root.editing && root.editingPart === 0) ? 0.0 : 1.0
                    anchors.centerIn: parent
                    text: root.two(root.hours())
                    color: "#111"
                    font.pixelSize: 42
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.editing && root.editingPart === 0) {
                            root.editing = false;
                            root.committed(root.totalSeconds);
                        } else {
                            root.editing = true;
                            root.editingPart = 0;
                        }
                    }
                }
            }

            Text {
                text: "h"
                color: "#666"
                font.pixelSize: 20
                anchors.verticalCenter: hoursBox.verticalCenter
            }
        }

        Rectangle {
            width: 2
            radius: 2
            height: parent.height
            color: "#e5e5e5"
            anchors.verticalCenter: parent.verticalCenter
        }

        // minutes case
        Row {

            Rectangle {
                id: minutesBox
                radius: 12
                width: 110
                height: 64
                clip: false

                Tumbler {
                    id: minutesWheel
                    visible: root.editing && root.editingPart === 1
                    width: minutesBox.width
                    height: 200
                    x: 0
                    y: parent.height / 2 - height / 2

                    model: Math.floor(60 / root.minuteStep)
                    currentIndex: Math.floor(root.minutes() / root.minuteStep)

                    onCurrentIndexChanged: {
                        if (!root.editing)
                            return;
                        root.setMinutes(currentIndex * root.minuteStep);
                    }

                    delegate: Item {
                        width: minutesWheel.width
                        height: 40

                        readonly property int v: modelData * root.minuteStep
                        readonly property bool current: index === minutesWheel.currentIndex

                        Text {
                            anchors.centerIn: parent
                            text: v < 10 ? ("0" + v) : ("" + v)
                            font.pixelSize: parent.current ? 42 : 22
                            font.bold: parent.current
                            color: "#111"
                            opacity: parent.current ? 1.0 : 0.35
                        }
                    }

                    // Fade TOP
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 40
                        z: 2
                        visible: root.editing && root.editingPart === 1
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

                    // Fade BOTTOM
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 40
                        z: 2
                        visible: root.editing && root.editingPart === 1

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

                    Component.onCompleted: console.log("hoursBox.x", hoursBox.x, "minutesBox.x", minutesBox.x)
                }

                Rectangle {
                    visible: root.editing && root.editingPart === 1
                    radius: 12
                    color: "#000000"
                    opacity: 0.04

                    width: (root.editingPart === 0) ? hoursBox.width : minutesBox.width
                    height: (root.editingPart === 0) ? hoursBox.height : minutesBox.height

                    x: (root.editingPart === 0) ? hoursBox.x : minutesBox.x
                    y: (root.editingPart === 0) ? hoursBox.y : minutesBox.y
                }

                Text {
                    opacity: (root.editing && root.editingPart === 1) ? 0.0 : 1.0
                    anchors.centerIn: parent
                    text: root.two(root.minutes())
                    color: "#111"
                    font.pixelSize: 42
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.editing && root.editingPart === 1) {
                            root.editing = false;
                            root.committed(root.totalSeconds);
                        } else {
                            root.editing = true;
                            root.editingPart = 1;
                        }
                    }
                }
            }

            Text {
                text: "m"
                color: "#666"
                font.pixelSize: 20
                anchors.verticalCenter: minutesBox.verticalCenter
            }
        }

        Rectangle {
            width: 2
            radius: 2
            height: parent.height
            color: "#e5e5e5"
            anchors.verticalCenter: parent.verticalCenter
        }

        // secondes case
        Row {

            Rectangle {
                id: secondesBox
                radius: 12
                width: 100
                height: 64
                clip: false

                Text {
                    anchors.centerIn: parent
                    text: root.two(root.seconds())
                    color: "#111"
                    font.pixelSize: 32
                    font.bold: true
                }
            }
            Text {
                text: "s"
                color: "#666"
                font.pixelSize: 20
                anchors.verticalCenter: secondesBox.verticalCenter
            }
        }

        Rectangle {
            width: 2
            radius: 2
            height: parent.height
            color: "#e5e5e5"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
