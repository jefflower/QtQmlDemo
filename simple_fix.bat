@echo off
:: 简化版快速修复 - 使用最简单的QML文件

echo ===================================
echo Simple Fix for QML Loading Issue
echo ===================================
echo.

:: 检查是否在正确的目录
if not exist QtQmlDemo.exe (
    echo ERROR: QtQmlDemo.exe not found!
    echo Please run this script in the deploy directory.
    pause
    exit /b 1
)

:: 创建qml目录
echo Creating qml directory...
if not exist qml mkdir qml

:: 创建简化的Main.qml（不依赖其他QML文件）
echo Creating simplified Main.qml...
(
echo import QtQuick 2.15
echo import QtQuick.Controls 2.15
echo import QtQuick.Layouts 1.15
echo import QtQuick.Controls.Material 2.15
echo.
echo ApplicationWindow {
echo     id: mainWindow
echo     width: 800
echo     height: 600
echo     visible: true
echo     title: "Qt QML Demo Application"
echo.
echo     Material.theme: Material.Light
echo     Material.accent: Material.Blue
echo.
echo     Rectangle {
echo         anchors.fill: parent
echo         color: "#f5f5f5"
echo.
echo         ColumnLayout {
echo             anchors.centerIn: parent
echo             spacing: 20
echo.
echo             Label {
echo                 text: "Welcome to Qt QML Demo"
echo                 font.pixelSize: 24
echo                 font.bold: true
echo                 Layout.alignment: Qt.AlignHCenter
echo             }
echo.
echo             Label {
echo                 text: "QML loaded successfully!"
echo                 font.pixelSize: 16
echo                 color: "green"
echo                 Layout.alignment: Qt.AlignHCenter
echo             }
echo.
echo             Button {
echo                 text: "Test Button"
echo                 Layout.alignment: Qt.AlignHCenter
echo                 onClicked: {
echo                     console.log("Button clicked!"^)
echo                     text = "Clicked!"
echo                 }
echo             }
echo.
echo             Row {
echo                 spacing: 10
echo                 Layout.alignment: Qt.AlignHCenter
echo.
echo                 Button {
echo                     text: "-"
echo                     property int counter: 0
echo                     onClicked: {
echo                         counter--
echo                         counterLabel.text = counter.toString(^)
echo                     }
echo                 }
echo.
echo                 Label {
echo                     id: counterLabel
echo                     text: "0"
echo                     font.pixelSize: 24
echo                     font.bold: true
echo                 }
echo.
echo                 Button {
echo                     text: "+"
echo                     property int counter: 0
echo                     onClicked: {
echo                         counter++
echo                         counterLabel.text = counter.toString(^)
echo                     }
echo                 }
echo             }
echo         }
echo     }
echo }
) > qml\Main.qml

:: 创建空的其他文件以防需要
echo Creating empty HomePage.qml...
(
echo import QtQuick 2.15
echo import QtQuick.Controls 2.15
echo Page { }
) > qml\HomePage.qml

echo Creating empty SettingsPage.qml...
(
echo import QtQuick 2.15
echo import QtQuick.Controls 2.15
echo Page { }
) > qml\SettingsPage.qml

echo Creating Card.qml without QtGraphicalEffects...
(
echo import QtQuick 2.15
echo import QtQuick.Controls.Material 2.15
echo.
echo Rectangle {
echo     color: Material.backgroundColor
echo     radius: 8
echo     border.color: Material.dividerColor
echo     border.width: 1
echo }
) > qml\Card.qml

echo.
echo ===================================
echo Simple fix applied!
echo QML files created in: %CD%\qml
echo.
echo Now try running QtQmlDemo.exe
echo ===================================
echo.

pause