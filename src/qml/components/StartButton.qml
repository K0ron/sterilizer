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
    property bool running: false
    signal clicked

    color: root.enabled ? "#18A558" : "#BDBDBD"
    opacity: root.enabled ? 1.0 : 0.7

    // Inner disc (background)
    Rectangle {
        id: innerDisc
        anchors.centerIn: parent
        width: 160
        height: 160
        radius: height / 2
        color: "#e7e7e7"
        z: 0
    }

    // === RADAR SWEEP (visible only when running) ===
    Item {
        id: radar
        anchors.fill: parent
        visible: root.running
        z: 1

        // rotating container
        Item {
            id: radarRot
            anchors.fill: parent

            // 1) CORE (fort, au milieu de l’anneau)
            Shape {
                anchors.fill: parent
                opacity: 0.20
                ShapePath {
                    strokeWidth: 8
                    strokeColor: "#ffffff"
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"
                    PathAngleArc {
                        centerX: root.width / 2
                        centerY: root.height / 2
                        radiusX: 86
                        radiusY: 86
                        startAngle: -12
                        sweepAngle: 18
                    }
                }
            }

            // 2) MID HALO (diffusion douce)
            Shape {
                anchors.fill: parent
                opacity: 0.07
                ShapePath {
                    strokeWidth: 18
                    strokeColor: "#ffffff"
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"
                    PathAngleArc {
                        centerX: root.width / 2
                        centerY: root.height / 2
                        radiusX: 88
                        radiusY: 88
                        startAngle: -16
                        sweepAngle: 26
                    }
                }
            }

            // 3) OUTER GLOW (diffusion externe)
            Shape {
                anchors.fill: parent
                opacity: 0.03
                ShapePath {
                    strokeWidth: 30
                    strokeColor: "#ffffff"
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"
                    PathAngleArc {
                        centerX: root.width / 2
                        centerY: root.height / 2
                        radiusX: 91
                        radiusY: 91
                        startAngle: -22
                        sweepAngle: 40
                    }
                }
            }
        }

        RotationAnimator {
            target: radarRot
            from: 0
            to: 360
            duration: 3000
            loops: Animation.Infinite
            running: radar.visible
        }
    }

    // Icon (play/pause)
    Image {
        id: icon
        anchors.centerIn: parent
        source: root.running ? "qrc:/qml/icons/pause-svgrepo-com.svg" : "qrc:/qml/icons/play-svgrepo-com.svg"
        width: 70
        height: 70
        z: 2
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled

        onClicked: {
            root.running = !root.running;
            root.clicked();
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
}
