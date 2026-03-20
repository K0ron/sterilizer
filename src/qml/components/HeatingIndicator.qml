import QtQuick

Item {
    id: root
    width: 92
    height: 22

    property bool active: false
    property real temperature: 0
    property real wavePhase: 0

    function waveValue(offset) {
        const t = (wavePhase + offset) % 1.0;
        return 0.5 + 0.5 * Math.sin(t * Math.PI * 2);
    }

    NumberAnimation on wavePhase {
        running: root.active
        from: 0
        to: 1
        duration: 1100
        loops: Animation.Infinite
    }

    Row {
        anchors.centerIn: parent
        spacing: 10

        Repeater {
            model: 3

            Rectangle {
                required property int index

                width: 12
                height: 12
                radius: 6
                color: root.temperature < 50 ? "#5BBE63"
                    : (root.temperature < 90 ? "#F0A53A" : "#D94A3A")
                readonly property real intensity: root.active ? root.waveValue(index * 0.16) : 0.0
                opacity: root.active ? (0.35 + intensity * 0.65) : 0.22
                scale: root.active ? (0.9 + intensity * 0.28) : 0.9
            }
        }
    }
}
