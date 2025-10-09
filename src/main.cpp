#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QDirIterator>
#include <QMessageBox>
#include <QApplication>
#include "backend.h"
#include "medicaldataprocessor.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    // 使用QApplication而不是QGuiApplication，以便显示消息框
    QApplication app(argc, argv);

    app.setOrganizationName("QtQmlDemo");
    app.setOrganizationDomain("qtqmldemo.example");
    app.setApplicationName("Qt QML Demo Application");

    // 输出调试信息
    qDebug() << "Application starting...";
    qDebug() << "Current directory:" << QDir::currentPath();
    qDebug() << "Application directory:" << QCoreApplication::applicationDirPath();

    // 设置Material样式
    QQuickStyle::setStyle("Material");

    qmlRegisterType<Backend>("com.example.backend", 1, 0, "Backend");
    qmlRegisterType<MedicalDataProcessor>("com.example.medical", 1, 0, "MedicalDataProcessor");

    QQmlApplicationEngine engine;

    Backend backend;
    // 创建医疗数据处理器实例
    MedicalDataProcessor processor;

    // 在加载QML之前设置context properties
    engine.rootContext()->setContextProperty("backend", &backend);
    engine.rootContext()->setContextProperty("medicalProcessor", &processor);

    qDebug() << "Context properties set: backend and medicalProcessor";

    // 首先尝试从资源文件加载
    QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    bool useFileSystem = false;

    // 检查QML资源是否存在
    if (!QFile::exists(":/qml/Main.qml")) {
        qWarning() << "Main.qml not found in resources, trying file system...";

        // 尝试从文件系统加载
        QString qmlPath = QCoreApplication::applicationDirPath() + "/qml/Main.qml";
        if (QFile::exists(qmlPath)) {
            url = QUrl::fromLocalFile(qmlPath);
            useFileSystem = true;
            qDebug() << "Loading QML from file system:" << qmlPath;
        } else {
            // 也尝试上级目录（开发环境）
            qmlPath = QCoreApplication::applicationDirPath() + "/../qml/Main.qml";
            if (QFile::exists(qmlPath)) {
                url = QUrl::fromLocalFile(qmlPath);
                useFileSystem = true;
                qDebug() << "Loading QML from development path:" << qmlPath;
            } else {
                qCritical() << "ERROR: Main.qml not found anywhere!";
                qDebug() << "Searched in:";
                qDebug() << "  - Resources (qrc:/qml/Main.qml)";
                qDebug() << "  - " << QCoreApplication::applicationDirPath() + "/qml/Main.qml";
                qDebug() << "  - " << QCoreApplication::applicationDirPath() + "/../qml/Main.qml";

                QMessageBox::critical(nullptr, "Error",
                    "Failed to load QML file.\n"
                    "Main.qml not found in resources or file system.\n\n"
                    "Please ensure either:\n"
                    "1. The qml.qrc file is properly compiled into the executable, or\n"
                    "2. The 'qml' folder exists next to the executable.");
                return -1;
            }
        }
    }

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            qCritical() << "Failed to load QML file:" << objUrl;
            QMessageBox::critical(nullptr, "Error",
                QString("Failed to load QML file:\n%1\n\n"
                       "Please check the console for more details.").arg(objUrl.toString()));
            QCoreApplication::exit(-1);
        } else if (obj) {
            qDebug() << "QML loaded successfully";
        }
    }, Qt::QueuedConnection);

    engine.load(url);

    // 检查是否有根对象被创建
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "No root objects created!";
        QMessageBox::critical(nullptr, "Error",
            "Failed to create QML root object.\n"
            "The application will now exit.");
        return -1;
    }

    qDebug() << "Starting event loop...";
    return app.exec();
}