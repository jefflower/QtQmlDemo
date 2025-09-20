import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import com.example.backend 1.0

ApplicationWindow {
    id: mainWindow
    width: 800
    height: 600
    visible: true
    title: qsTr("Qt QML Demo Application")

    Material.theme: Material.Light
    Material.accent: Material.Blue

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            spacing: 20

            Label {
                text: mainWindow.title
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                font.bold: true
                font.pixelSize: 18
            }

            Label {
                text: backend.currentTime
                font.pixelSize: 14
                color: Material.accent
            }
        }
    }

    // 简化的主页面内容
    Rectangle {
        anchors.fill: parent
        color: "#f5f5f5"

        ScrollView {
            anchors.fill: parent
            contentWidth: -1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                // 欢迎卡片
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150
                    radius: 8
                    color: "white"
                    border.color: "#e0e0e0"

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10

                        Label {
                            text: qsTr("Welcome to Qt QML Demo")
                            font.pixelSize: 24
                            font.bold: true
                            color: Material.primary
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: backend.message
                            font.pixelSize: 16
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Button {
                            text: qsTr("Test Connection")
                            Layout.alignment: Qt.AlignHCenter
                            Material.background: Material.accent
                            onClicked: {
                                backend.logMessage("Button clicked at " + new Date().toLocaleTimeString())
                            }
                        }
                    }
                }

                // 计数器卡片
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200
                    radius: 8
                    color: "white"
                    border.color: "#e0e0e0"

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        Label {
                            text: qsTr("Counter Demo")
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.primary
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: backend.counter
                            font.pixelSize: 48
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                            color: Material.accent
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 10

                            Button {
                                text: qsTr("−")
                                onClicked: backend.decrementCounter()
                            }

                            Button {
                                text: qsTr("Reset")
                                onClicked: backend.resetCounter()
                            }

                            Button {
                                text: qsTr("+")
                                onClicked: backend.incrementCounter()
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }

    Component.onCompleted: {
        backend.logMessage("Application started successfully")
        console.log("QML loaded and running")
    }
}