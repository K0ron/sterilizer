import QtQuick
import QtQuick.Controls
import "components"

ApplicationWindow {
    visible: true
    width: 700
    height: 480
    title: "Sterilizer"
    color: "#f5f5f5"

    TimeInlinePicker {
        anchors.centerIn: parent
        width: 600
        height: 100
        totalSeconds: (1 * 3600) + (29 * 60)
        onCommitted: s => console.log("Committed:", s)
    }
}
