import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Page {
    id: settingsPage
    title: qsTr("Settings")

    ScrollView {
        anchors.fill: parent
        contentWidth: -1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Label {
                text: qsTr("Application Settings")
                font.pixelSize: 28
                font.bold: true
                color: Material.primary
            }

            GroupBox {
                title: qsTr("Theme Settings")
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    RadioButton {
                        id: lightTheme
                        text: qsTr("Light Theme")
                        checked: Material.theme === Material.Light
                        onToggled: {
                            if (checked) {
                                Material.theme = Material.Light
                                backend.logMessage("Switched to Light theme")
                            }
                        }
                    }

                    RadioButton {
                        id: darkTheme
                        text: qsTr("Dark Theme")
                        checked: Material.theme === Material.Dark
                        onToggled: {
                            if (checked) {
                                Material.theme = Material.Dark
                                backend.logMessage("Switched to Dark theme")
                            }
                        }
                    }

                    RadioButton {
                        id: systemTheme
                        text: qsTr("System Theme")
                        checked: Material.theme === Material.System
                        onToggled: {
                            if (checked) {
                                Material.theme = Material.System
                                backend.logMessage("Switched to System theme")
                            }
                        }
                    }
                }
            }

            GroupBox {
                title: qsTr("Accent Color")
                Layout.fillWidth: true

                GridLayout {
                    columns: 4
                    anchors.fill: parent
                    rowSpacing: 10
                    columnSpacing: 10

                    Repeater {
                        model: [
                            { name: "Red", color: Material.Red },
                            { name: "Pink", color: Material.Pink },
                            { name: "Purple", color: Material.Purple },
                            { name: "DeepPurple", color: Material.DeepPurple },
                            { name: "Indigo", color: Material.Indigo },
                            { name: "Blue", color: Material.Blue },
                            { name: "LightBlue", color: Material.LightBlue },
                            { name: "Cyan", color: Material.Cyan },
                            { name: "Teal", color: Material.Teal },
                            { name: "Green", color: Material.Green },
                            { name: "LightGreen", color: Material.LightGreen },
                            { name: "Lime", color: Material.Lime },
                            { name: "Yellow", color: Material.Yellow },
                            { name: "Amber", color: Material.Amber },
                            { name: "Orange", color: Material.Orange },
                            { name: "DeepOrange", color: Material.DeepOrange }
                        ]

                        delegate: Button {
                            text: modelData.name
                            Layout.fillWidth: true
                            Material.background: modelData.color
                            onClicked: {
                                Material.accent = modelData.color
                                backend.logMessage("Accent color changed to: " + modelData.name)
                            }
                        }
                    }
                }
            }

            GroupBox {
                title: qsTr("Notification Settings")
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Switch {
                        text: qsTr("Enable Notifications")
                        checked: true
                        onToggled: {
                            backend.logMessage("Notifications " + (checked ? "enabled" : "disabled"))
                        }
                    }

                    Switch {
                        text: qsTr("Sound Effects")
                        checked: false
                        onToggled: {
                            backend.logMessage("Sound effects " + (checked ? "enabled" : "disabled"))
                        }
                    }

                    Switch {
                        text: qsTr("Vibration")
                        checked: true
                        onToggled: {
                            backend.logMessage("Vibration " + (checked ? "enabled" : "disabled"))
                        }
                    }
                }
            }

            GroupBox {
                title: qsTr("数据库代理服务")
                Layout.fillWidth: true

                ColumnLayout {
                    width: parent.width
                    spacing: 15

                    Label {
                        text: qsTr("配置数据库代理服务的端口和地址")
                        font.pixelSize: 12
                        color: Material.color(Material.Grey)
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 10
                        columnSpacing: 10

                        Label {
                            text: qsTr("代理端口:")
                            font.pixelSize: 14
                        }

                        TextField {
                            id: proxyPortInput
                            Layout.fillWidth: true
                            placeholderText: "8000"
                            text: backend.getSetting("proxy_port", "8000")
                            validator: IntValidator { bottom: 1024; top: 65535 }
                            font.pixelSize: 14
                        }

                        Label {
                            text: qsTr("代理地址:")
                            font.pixelSize: 14
                        }

                        TextField {
                            id: proxyHostInput
                            Layout.fillWidth: true
                            placeholderText: "localhost"
                            text: backend.getSetting("proxy_host", "localhost")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Button {
                            text: qsTr("保存设置")
                            highlighted: true
                            onClicked: {
                                backend.setSetting("proxy_port", proxyPortInput.text)
                                backend.setSetting("proxy_host", proxyHostInput.text)
                                backend.logMessage("代理服务配置已保存: " + proxyHostInput.text + ":" + proxyPortInput.text)
                                saveSuccessDialog.open()
                            }
                        }

                        Label {
                            text: qsTr("注意：需要重启代理服务才能生效")
                            font.pixelSize: 11
                            color: Material.color(Material.Orange)
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            GroupBox {
                title: qsTr("Advanced Settings")
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Font Size:")
                            Layout.preferredWidth: 100
                        }

                        Slider {
                            id: fontSizeSlider
                            Layout.fillWidth: true
                            from: 10
                            to: 24
                            value: 14
                            stepSize: 1
                            snapMode: Slider.SnapAlways

                            onValueChanged: {
                                fontSizeLabel.text = value.toFixed(0) + " px"
                            }
                        }

                        Label {
                            id: fontSizeLabel
                            text: "14 px"
                            Layout.preferredWidth: 50
                        }
                    }

                    CheckBox {
                        text: qsTr("Developer Mode")
                        onToggled: {
                            backend.logMessage("Developer mode " + (checked ? "enabled" : "disabled"))
                        }
                    }

                    CheckBox {
                        text: qsTr("Show Debug Info")
                        onToggled: {
                            backend.logMessage("Debug info " + (checked ? "enabled" : "disabled"))
                        }
                    }
                }
            }

            Button {
                text: qsTr("Reset All Settings")
                Layout.fillWidth: true
                Material.background: Material.Red
                onClicked: {
                    backend.logMessage("Settings reset requested")
                    resetDialog.open()
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    Dialog {
        id: saveSuccessDialog
        title: qsTr("保存成功")
        modal: true
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        standardButtons: Dialog.Ok

        Label {
            text: qsTr("代理服务配置已保存，需要重启代理服务才能生效")
        }
    }

    Dialog {
        id: resetDialog
        title: qsTr("Reset Settings")
        modal: true
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        standardButtons: Dialog.Yes | Dialog.No

        Label {
            text: qsTr("Are you sure you want to reset all settings to default?")
        }

        onAccepted: {
            backend.logMessage("Settings reset confirmed")
            lightTheme.checked = true
            Material.accent = Material.Blue
        }

        onRejected: {
            backend.logMessage("Settings reset cancelled")
        }
    }
}