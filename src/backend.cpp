#include "backend.h"
#include <QDebug>
#include <QTimer>

Backend::Backend(QObject *parent)
    : QObject(parent)
    , m_message("Hello from C++ Backend!")
    , m_counter(0)
{
    updateTime();

    QTimer *timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &Backend::updateTime);
    timer->start(1000);
}

QString Backend::message() const
{
    return m_message;
}

void Backend::setMessage(const QString &message)
{
    if (m_message != message) {
        m_message = message;
        emit messageChanged();
    }
}

int Backend::counter() const
{
    return m_counter;
}

void Backend::setCounter(int counter)
{
    if (m_counter != counter) {
        m_counter = counter;
        emit counterChanged();
    }
}

QString Backend::currentTime() const
{
    return m_currentTime;
}

void Backend::incrementCounter()
{
    setCounter(m_counter + 1);
    qDebug() << "Counter incremented to:" << m_counter;
}

void Backend::decrementCounter()
{
    setCounter(m_counter - 1);
    qDebug() << "Counter decremented to:" << m_counter;
}

void Backend::resetCounter()
{
    setCounter(0);
    qDebug() << "Counter reset to 0";
}

void Backend::updateTime()
{
    m_currentTime = QDateTime::currentDateTime().toString("hh:mm:ss");
    emit currentTimeChanged();
}

QString Backend::processText(const QString &text)
{
    QString processed = text.toUpper();
    QString result = QString("Processed: %1 (length: %2)").arg(processed).arg(text.length());
    emit dataProcessed(result);
    return result;
}

void Backend::logMessage(const QString &msg)
{
    qDebug() << "[QML Log]:" << msg;
}