#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include "backend.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setOrganizationName("QtQmlDemo");
    app.setOrganizationDomain("qtqmldemo.example");
    app.setApplicationName("Qt QML Demo Application");

    // 设置Material样式
    QQuickStyle::setStyle("Material");

    qmlRegisterType<Backend>("com.example.backend", 1, 0, "Backend");

    QQmlApplicationEngine engine;

    Backend backend;
    engine.rootContext()->setContextProperty("backend", &backend);

    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}