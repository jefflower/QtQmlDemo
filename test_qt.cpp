#include <QApplication>
#include <QWidget>
#include <QLabel>
#include <QVBoxLayout>
#include <QPushButton>
#include <QMessageBox>
#include <QDebug>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qDebug() << "Qt Version:" << qVersion();
    qDebug() << "Application Path:" << QCoreApplication::applicationDirPath();

    QWidget window;
    window.setWindowTitle("Qt Test - Click button to test");
    window.resize(400, 200);

    QVBoxLayout *layout = new QVBoxLayout(&window);

    QLabel *label = new QLabel("If you can see this window, Qt is working!");
    label->setAlignment(Qt::AlignCenter);
    layout->addWidget(label);

    QPushButton *button = new QPushButton("Click to test QMessageBox");
    layout->addWidget(button);

    QObject::connect(button, &QPushButton::clicked, [&]() {
        QMessageBox::information(&window, "Success",
            "Qt is working correctly!\n\n"
            "Qt Version: " + QString(qVersion()) + "\n"
            "This confirms that:\n"
            "- Qt Core is working\n"
            "- Qt Widgets is working\n"
            "- Qt GUI is working");
    });

    window.show();

    return app.exec();
}