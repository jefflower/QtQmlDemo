import QtQuick 2.15
import QtQuick.Controls.Material 2.15

Rectangle {
    color: Material.backgroundColor
    radius: 8
    border.color: Material.dividerColor
    border.width: 1

    // 简单的阴影效果，不依赖QtGraphicalEffects
    Rectangle {
        anchors.fill: parent
        anchors.margins: -2
        radius: parent.radius + 2
        color: "#10000000"
        z: -1
    }
}