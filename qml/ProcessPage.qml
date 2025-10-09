import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Page {
    id: processPage
    title: qsTr("医保数据处理")

    // 计算上个月的日期范围
    function getLastMonthRange() {
        var today = new Date()
        var lastMonth = new Date(today.getFullYear(), today.getMonth() - 1, 1)

        // 上个月第一天
        var firstDay = new Date(lastMonth.getFullYear(), lastMonth.getMonth(), 1)

        // 上个月最后一天
        var lastDay = new Date(lastMonth.getFullYear(), lastMonth.getMonth() + 1, 0)

        // 格式化日期为 yyyy-MM-dd HH:mm:ss
        function formatDate(date, isEndOfDay) {
            var year = date.getFullYear()
            var month = String(date.getMonth() + 1).padStart(2, '0')
            var day = String(date.getDate()).padStart(2, '0')

            if (isEndOfDay) {
                return year + "-" + month + "-" + day + " 23:59:59"
            } else {
                return year + "-" + month + "-" + day + " 00:00:00"
            }
        }

        return {
            start: formatDate(firstDay, false),
            end: formatDate(lastDay, true)
        }
    }

    Component.onCompleted: {
        var range = getLastMonthRange()
        startTimeInput.text = range.start
        endTimeInput.text = range.end
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 8

        // 1. 数据库连接状态区
        GroupBox {
            Layout.fillWidth: true

            label: Label {
                text: "数据库状态"
                font.bold: true
                font.pixelSize: 14
            }

            RowLayout {
                width: parent.width
                spacing: 10

                Label {
                    text: "连接状态:"
                    font.pixelSize: 14
                }

                Rectangle {
                    width: 16
                    height: 16
                    radius: 8
                    color: medicalProcessor.dbConnected ? Material.color(Material.Green) : Material.color(Material.Red)
                }

                Label {
                    text: medicalProcessor.dbConnected ? "已连接" : "未连接"
                    font.pixelSize: 14
                    color: medicalProcessor.dbConnected ? Material.color(Material.Green) : Material.color(Material.Red)
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "测试连接"
                    enabled: !medicalProcessor.isProcessing
                    onClicked: medicalProcessor.testDatabaseConnection()
                }

                Button {
                    text: "清空日志"
                    enabled: !medicalProcessor.isProcessing
                    onClicked: medicalProcessor.clearLog()
                }
            }
        }

        // 2. 时间范围输入区
        GroupBox {
            Layout.fillWidth: true

            label: RowLayout {
                width: parent.width
                spacing: 10

                Label {
                    text: "时间范围设置"
                    font.bold: true
                    font.pixelSize: 14
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: medicalProcessor.isProcessing ? "停止执行" : "开始执行"
                    flat: true
                    highlighted: true
                    font.pixelSize: 12
                    Material.foreground: medicalProcessor.isProcessing ? Material.color(Material.Red) : Material.color(Material.Blue)

                    onClicked: {
                        if (medicalProcessor.isProcessing) {
                            medicalProcessor.stopProcess()
                        } else {
                            if (startTimeInput.text.length === 0 || endTimeInput.text.length === 0) {
                                errorDialog.text = "请输入开始时间和结束时间"
                                errorDialog.open()
                                return
                            }
                            medicalProcessor.startProcess(startTimeInput.text, endTimeInput.text)
                        }
                    }
                }
            }

            GridLayout {
                width: parent.width
                columns: 2
                rowSpacing: 10
                columnSpacing: 10

                Label {
                    text: "开始时间:"
                    font.pixelSize: 14
                }

                TextField {
                    id: startTimeInput
                    Layout.fillWidth: true
                    placeholderText: "yyyy-MM-dd HH:mm:ss"
                    text: ""
                    enabled: !medicalProcessor.isProcessing
                }

                Label {
                    text: "结束时间:"
                    font.pixelSize: 14
                }

                TextField {
                    id: endTimeInput
                    Layout.fillWidth: true
                    placeholderText: "yyyy-MM-dd HH:mm:ss"
                    text: ""
                    enabled: !medicalProcessor.isProcessing
                }
            }
        }

        // 3. 进度显示区
        GroupBox {
            Layout.fillWidth: true
            Layout.fillHeight: true

            label: RowLayout {
                width: parent.width
                spacing: 10

                Label {
                    text: "执行进度"
                    font.bold: true
                    font.pixelSize: 14
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "查看详细日志"
                    flat: true
                    highlighted: true
                    font.pixelSize: 12
                    onClicked: logDialog.open()
                }
            }

            ColumnLayout {
                width: parent.width
                spacing: 10

                // 进度条
                ProgressBar {
                    Layout.fillWidth: true
                    value: medicalProcessor.totalDays > 0 ? medicalProcessor.currentDay / medicalProcessor.totalDays : 0
                    indeterminate: medicalProcessor.isProcessing && medicalProcessor.totalDays === 0
                }

                // 进度文本
                Label {
                    text: medicalProcessor.progressText || "等待开始..."
                    font.pixelSize: 14
                    font.bold: true
                    color: Material.accent
                }

                // 当前处理患者信息
                Label {
                    text: medicalProcessor.currentPatientName
                          ? "当前处理: " + medicalProcessor.currentPatientName + "  " + medicalProcessor.currentIdCertNo
                          : ""
                    font.pixelSize: 13
                    color: Material.color(Material.Blue)
                    visible: medicalProcessor.isProcessing && medicalProcessor.currentPatientName !== ""
                }

                // 统计信息网格
                GridLayout {
                    Layout.fillWidth: true
                    columns: 4
                    rowSpacing: 5
                    columnSpacing: 15

                    Label {
                        text: "总天数: " + medicalProcessor.totalDays
                        font.pixelSize: 12
                    }

                    Label {
                        text: "当前天: " + medicalProcessor.currentDay
                        font.pixelSize: 12
                    }

                    Label {
                        text: "总记录: " + medicalProcessor.totalRecords
                        font.pixelSize: 12
                    }

                    Label {
                        text: "已处理: " + medicalProcessor.processedRecords
                        font.pixelSize: 12
                    }

                    Label {
                        text: "成功: " + medicalProcessor.successCount
                        font.pixelSize: 12
                        color: Material.color(Material.Green)
                    }

                    Label {
                        text: "失败: " + medicalProcessor.failCount
                        font.pixelSize: 12
                        color: Material.color(Material.Red)
                    }

                    Label {
                        text: medicalProcessor.totalRecords > 0
                            ? "成功率: " + Math.round(medicalProcessor.successCount / medicalProcessor.processedRecords * 100) + "%"
                            : "成功率: --"
                        font.pixelSize: 12
                    }
                }
            }
        }
    }

    // 错误对话框
    Dialog {
        id: errorDialog
        title: "错误"
        modal: true
        anchors.centerIn: parent

        property alias text: errorLabel.text

        ColumnLayout {
            Label {
                id: errorLabel
                text: ""
            }

            Button {
                text: "确定"
                onClicked: errorDialog.close()
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    // 完成对话框
    Dialog {
        id: completeDialog
        title: "完成"
        modal: true
        anchors.centerIn: parent

        ColumnLayout {
            Label {
                text: "数据处理已完成！\n\n" +
                      "总计处理: " + medicalProcessor.totalDays + " 天, " + medicalProcessor.processedRecords + " 条记录\n" +
                      "成功: " + medicalProcessor.successCount + " 条\n" +
                      "失败: " + medicalProcessor.failCount + " 条"
            }

            Button {
                text: "确定"
                onClicked: completeDialog.close()
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    // 监听处理完成信号
    Connections {
        target: medicalProcessor
        function onProcessCompleted() {
            completeDialog.open()
        }
    }

    // 监听错误信号
    Connections {
        target: medicalProcessor
        function onErrorOccurred(error) {
            errorDialog.text = "发生错误: " + error
            errorDialog.open()
        }
    }

    // 日志查看对话框
    Dialog {
        id: logDialog
        title: "执行日志"
        modal: true
        width: parent.width * 0.9
        height: parent.height * 0.8
        anchors.centerIn: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            // 日志内容区域
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                TextArea {
                    id: logTextArea
                    text: medicalProcessor.logText
                    readOnly: true
                    wrapMode: TextArea.Wrap
                    font.family: "Courier New"
                    font.pixelSize: 12
                    selectByMouse: true

                    // 当日志更新时自动滚动到底部
                    onTextChanged: {
                        logTextArea.cursorPosition = logTextArea.length
                    }
                }
            }

            // 按钮区域
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Item { Layout.fillWidth: true }

                Button {
                    text: "清空日志"
                    enabled: !medicalProcessor.isProcessing
                    onClicked: medicalProcessor.clearLog()
                }

                Button {
                    text: "关闭"
                    highlighted: true
                    onClicked: logDialog.close()
                }
            }
        }
    }

}
