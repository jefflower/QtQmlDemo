#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>
#include <QDateTime>

class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)
    Q_PROPERTY(int counter READ counter WRITE setCounter NOTIFY counterChanged)
    Q_PROPERTY(QString currentTime READ currentTime NOTIFY currentTimeChanged)

public:
    explicit Backend(QObject *parent = nullptr);

    QString message() const;
    void setMessage(const QString &message);

    int counter() const;
    void setCounter(int counter);

    QString currentTime() const;

public slots:
    void incrementCounter();
    void decrementCounter();
    void resetCounter();
    void updateTime();
    QString processText(const QString &text);
    void logMessage(const QString &msg);

signals:
    void messageChanged();
    void counterChanged();
    void currentTimeChanged();
    void dataProcessed(const QString &result);

private:
    QString m_message;
    int m_counter;
    QString m_currentTime;
};

#endif // BACKEND_H