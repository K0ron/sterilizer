import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Rectangle {
    id: root
    width: 250
    height: 250
    radius: height / 2
    readonly property real size: Math.min(width, height)
    readonly property real outerRadius: size / 2
    readonly property real innerRadius: innerDisc.width / 2
    readonly property real ringThickness: outerRadius - innerRadius
    readonly property real ringRadius: innerRadius + ringThickness / 2
    readonly property real iconSize: size * 0.36

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
        width: root.size * 0.92
        height: root.size * 0.92
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
                    strokeWidth: Math.max(2, root.ringThickness * 0.4)
                    strokeColor: "#ffffff"
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"
                    PathAngleArc {
                        centerX: root.width / 2
                        centerY: root.height / 2
                        radiusX: root.ringRadius
                        radiusY: root.ringRadius
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
                    strokeWidth: Math.max(4, root.ringThickness * 0.9)
                    strokeColor: "#ffffff"
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"
                    PathAngleArc {
                        centerX: root.width / 2
                        centerY: root.height / 2
                        radiusX: root.ringRadius
                        radiusY: root.ringRadius
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
                    strokeWidth: Math.max(6, root.ringThickness * 1.5)
                    strokeColor: "#ffffff"
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"
                    PathAngleArc {
                        centerX: root.width / 2
                        centerY: root.height / 2
                        radiusX: root.ringRadius
                        radiusY: root.ringRadius
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
        source: root.running ? (root.enabled ? "qrc:/qml/icons/pause-svgrepo-com.svg" : "qrc:/qml/icons/pause-disabled.svg") : (root.enabled ? "qrc:/qml/icons/play-svgrepo-com.svg" : "qrc:/qml/icons/play-disabled.svg")
        width: root.iconSize
        height: root.iconSize
        fillMode: Image.PreserveAspectFit
        z: 2

        onStatusChanged: {
            if (status === Image.Error) {
                console.log("Failed to load icon:", source);
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled

        onClicked: {
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
