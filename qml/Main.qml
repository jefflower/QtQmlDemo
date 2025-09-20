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

    property int currentPageIndex: 0

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            spacing: 20

            ToolButton {
                icon.source: "qrc:/resources/logo.png"
                enabled: false
            }

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

            ToolButton {
                text: "☰"
                font.pixelSize: 20
                onClicked: drawer.open()
            }
        }
    }

    Drawer {
        id: drawer
        width: mainWindow.width * 0.33
        height: mainWindow.height

        ListView {
            anchors.fill: parent

            model: ListModel {
                ListElement { title: "Home"; icon: "home" }
                ListElement { title: "Settings"; icon: "settings" }
            }

            delegate: ItemDelegate {
                width: parent.width
                text: model.title

                onClicked: {
                    mainWindow.currentPageIndex = index
                    drawer.close()
                }

                highlighted: mainWindow.currentPageIndex === index
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: mainWindow.currentPageIndex

        onCurrentIndexChanged: {
            mainWindow.currentPageIndex = currentIndex
        }

        HomePage {
            id: homePage
        }

        SettingsPage {
            id: settingsPage
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("Home")
            onClicked: mainWindow.currentPageIndex = 0
        }

        TabButton {
            text: qsTr("Settings")
            onClicked: mainWindow.currentPageIndex = 1
        }
    }

    Component.onCompleted: {
        backend.logMessage("Application started")
    }
}