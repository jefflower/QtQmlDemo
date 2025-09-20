import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtGraphicalEffects 1.15

Rectangle {
    color: Material.backgroundColor
    radius: 8
    border.color: Material.dividerColor
    border.width: 1

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 2
        radius: 8
        samples: 17
        color: "#20000000"
    }
}