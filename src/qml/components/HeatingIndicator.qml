import QtQuick

Item {
    id: root
    width: 200
    height: 6

    property bool active: false
    property real temperature: 0
    property real targetTemperature: 100
    readonly property real progress: {
        if (targetTemperature <= 0)
            return 0;
        return Math.max(0, Math.min(1, temperature / targetTemperature));
    }
    readonly property color fillColor: progress < 0.5 ? "#5BBE63" : (progress < 0.9 ? "#F0A53A" : "#D94A3A")

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: "#d7d7d7"
        opacity: 0.75
    }

    Rectangle {
        id: fill
        width: parent.width * root.progress
        height: parent.height
        radius: height / 2
        color: root.fillColor
        clip: true

        Behavior on width {
            NumberAnimation {
                duration: 260
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: '#ff0000'
            opacity: 0.08
        }

        Rectangle {
            id: shimmer
            width: 36
            height: parent.height + 8
            y: -4
            radius: width / 2
            visible: root.active && fill.width > 0
            color: "#ffffff"
            opacity: 0.24
            rotation: 12
            x: -width

            SequentialAnimation on x {
                running: root.active && fill.width > 0
                loops: Animation.Infinite

                PauseAnimation {
                    duration: 120
                }
                NumberAnimation {
                    from: -shimmer.width
                    to: Math.max(fill.width - shimmer.width * 0.35, -shimmer.width)
                    duration: 900
                    easing.type: Easing.InOutSine
                }
                PauseAnimation {
                    duration: 180
                }
            }
        }
    }
}
