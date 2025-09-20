@echo off
:: 快速修复脚本 - 将QML文件复制到部署目录

echo ===================================
echo Quick Fix for QML Loading Issue
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

:: 复制QML文件
echo Copying QML files...

:: 创建Main.qml
echo Creating Main.qml...
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
echo     title: qsTr("Qt QML Demo Application"^)
echo.
echo     Material.theme: Material.Light
echo     Material.accent: Material.Blue
echo.
echo     Rectangle {
echo         anchors.fill: parent
echo         color: "#f0f0f0"
echo.
echo         Column {
echo             anchors.centerIn: parent
echo             spacing: 20
echo.
echo             Text {
echo                 text: "Qt QML Demo Application"
echo                 font.pixelSize: 24
echo                 font.bold: true
echo                 anchors.horizontalCenter: parent.horizontalCenter
echo             }
echo.
echo             Text {
echo                 text: "QML loaded successfully from file system!"
echo                 font.pixelSize: 16
echo                 anchors.horizontalCenter: parent.horizontalCenter
echo                 color: "green"
echo             }
echo.
echo             Button {
echo                 text: "Click Me"
echo                 anchors.horizontalCenter: parent.horizontalCenter
echo                 onClicked: {
echo                     console.log("Button clicked!"^)
echo                     text = "Clicked!"
echo                 }
echo             }
echo         }
echo     }
echo }
) > qml\Main.qml

:: 从GitHub下载正确的QML文件
echo Downloading correct QML files from GitHub...

:: 使用PowerShell下载文件
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jefflower/QtQmlDemo/main/qml/HomePage.qml' -OutFile 'qml\HomePage.qml'}" 2>nul
if %errorlevel% neq 0 (
    echo Failed to download HomePage.qml, creating simplified version...
    (
    echo import QtQuick 2.15
    echo import QtQuick.Controls 2.15
    echo import QtQuick.Layouts 1.15
    echo.
    echo Page {
    echo     title: qsTr("Home"^)
    echo     ColumnLayout {
    echo         anchors.centerIn: parent
    echo         spacing: 20
    echo         Label {
    echo             text: qsTr("Welcome to Qt QML Demo"^)
    echo             font.pixelSize: 24
    echo             font.bold: true
    echo         }
    echo         Label {
    echo             text: qsTr("QML loaded successfully!"^)
    echo             font.pixelSize: 16
    echo         }
    echo         Button {
    echo             text: qsTr("Test Button"^)
    echo             onClicked: console.log("Button clicked!"^)
    echo         }
    echo     }
    echo }
    ) > qml\HomePage.qml
)

powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jefflower/QtQmlDemo/main/qml/SettingsPage.qml' -OutFile 'qml\SettingsPage.qml'}" 2>nul
if %errorlevel% neq 0 (
    echo Creating SettingsPage.qml...
    (
    echo import QtQuick 2.15
    echo import QtQuick.Controls 2.15
    echo.
    echo Page {
    echo     title: qsTr("Settings"^)
    echo     Label {
    echo         text: qsTr("Settings Page"^)
    echo         anchors.centerIn: parent
    echo     }
    echo }
    ) > qml\SettingsPage.qml
)

powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jefflower/QtQmlDemo/main/qml/Card.qml' -OutFile 'qml\Card.qml'}" 2>nul
if %errorlevel% neq 0 (
    echo Creating Card.qml...
    (
    echo import QtQuick 2.15
    echo import QtQuick.Controls 2.15
    echo import QtQuick.Controls.Material 2.15
    echo.
    echo Rectangle {
    echo     id: card
    echo     radius: 8
    echo     color: Material.background
    echo     border.color: Material.dividerColor
    echo     border.width: 1
    echo.
    echo     layer.enabled: true
    echo }
    ) > qml\Card.qml
)

echo.
echo QML files created successfully!
echo.
echo Directory structure:
dir /b qml\

echo.
echo ===================================
echo Fix Applied! Try running QtQmlDemo.exe now.
echo ===================================
echo.

pause