import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Page {
    id: homePage
    title: qsTr("Home")

    ScrollView {
        anchors.fill: parent
        contentWidth: -1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 200

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    Label {
                        text: qsTr("Welcome to Qt QML Demo")
                        font.pixelSize: 24
                        font.bold: true
                        color: Material.primary
                    }

                    Label {
                        text: backend.message
                        font.pixelSize: 16
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }

                    TextField {
                        id: messageInput
                        Layout.fillWidth: true
                        placeholderText: qsTr("Enter new message")
                        onAccepted: {
                            backend.message = text
                            backend.logMessage("Message changed to: " + text)
                        }
                    }

                    Button {
                        text: qsTr("Update Message")
                        Material.background: Material.accent
                        onClicked: {
                            backend.message = messageInput.text
                            backend.logMessage("Message updated via button")
                        }
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 250

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 15

                    Label {
                        text: qsTr("Counter Demo")
                        font.pixelSize: 20
                        font.bold: true
                        color: Material.primary
                    }

                    Label {
                        text: backend.counter
                        font.pixelSize: 48
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                        color: Material.accent
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10

                        Button {
                            text: qsTr("Decrement")
                            onClicked: backend.decrementCounter()
                            Material.background: Material.Red
                        }

                        Button {
                            text: qsTr("Reset")
                            onClicked: backend.resetCounter()
                            Material.background: Material.Grey
                        }

                        Button {
                            text: qsTr("Increment")
                            onClicked: backend.incrementCounter()
                            Material.background: Material.Green
                        }
                    }

                    ProgressBar {
                        Layout.fillWidth: true
                        value: backend.counter / 100.0
                        from: 0
                        to: 1
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 200

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    Label {
                        text: qsTr("Text Processor")
                        font.pixelSize: 20
                        font.bold: true
                        color: Material.primary
                    }

                    TextField {
                        id: textInput
                        Layout.fillWidth: true
                        placeholderText: qsTr("Enter text to process")
                    }

                    Button {
                        text: qsTr("Process Text")
                        Layout.fillWidth: true
                        Material.background: Material.accent
                        onClicked: {
                            if (textInput.text.length > 0) {
                                var result = backend.processText(textInput.text)
                                processedLabel.text = result
                            }
                        }
                    }

                    Label {
                        id: processedLabel
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        color: Material.accent
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}

