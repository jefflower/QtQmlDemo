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

    QQmlApplicationEngine engine;

    Backend backend;
    engine.rootContext()->setContextProperty("backend", &backend);

    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));

    // 检查QML资源是否存在
    if (!QFile::exists(":/qml/Main.qml")) {
        qCritical() << "ERROR: Main.qml not found in resources!";
        qDebug() << "Available resources:";
        QDirIterator it(":", QDirIterator::Subdirectories);
        while (it.hasNext()) {
            qDebug() << it.next();
        }
        QMessageBox::critical(nullptr, "Error",
            "Failed to load QML resources.\n"
            "Main.qml not found in embedded resources.\n\n"
            "This usually means the resource file (qml.qrc) was not properly compiled.");
        return -1;
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