#ifndef STERILIZER_H
#define STERILIZER_H

#include <QObject>
#include <chrono>
#include <string>

enum class State {
    IDLE,
    HEATING,
    HOLD,
    FINISHED,
    ERROR,
    PAUSED,
};

struct Configuration {
    float targetTemperature = 0.0f;
    int durationSeconds = 0;
};

class Sterilizer : public QObject {
    Q_OBJECT

    Q_PROPERTY(float temperature READ temperature NOTIFY temperatureChanged)
    Q_PROPERTY(int state READ stateInt NOTIFY stateChanged)
    Q_PROPERTY(int remainingTime READ remainingTime NOTIFY remainingTimeChanged)

public:
    explicit Sterilizer(QObject* parent = nullptr);

    Q_INVOKABLE void configure(float temperature, int durationSec);
    Q_INVOKABLE void start();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void emergencyStop();
    Q_INVOKABLE void reset();

    void update();

    float temperature() const;
    State state() const;
    int remainingTime() const;

    int stateInt() const { return static_cast<int>(state()); }

signals:
    void temperatureChanged();
    void stateChanged();
    void remainingTimeChanged();
    void errorOccurred(QString reason);

private:

    void checkOverheat();
    void triggerError(const std::string& reason);

private:
    Configuration config;
    State currentState = State::IDLE;

    float currentTemperature = 20.0f;
    bool heaterActive = false;

    bool timerActive = false;
    std::chrono::steady_clock::time_point timerStart{};
    std::chrono::steady_clock::time_point lastHeatUpdate{};
    
    int m_remainingTime = 0;

    static constexpr double MAX_TEMPERATURE = 150.0;
    static constexpr double OVER_TARGET_MARGIN = 10.0;

};

#endif // STERILIZER_H
