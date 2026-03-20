#include "sterilizer.h"
#include <QString>
#include <iostream>
#include <iomanip>
#include <QDebug>
using namespace std;


Sterilizer::Sterilizer(QObject* parent) : QObject(parent) {
    currentTemperature = 30.0f; // Ambient temperature
    currentState = State::IDLE;
    heaterActive = false;
    timerActive = false;

    config.targetTemperature = 0.0f;
    config.durationSeconds = 0;

    lastDisplayRemainingTime = -1;

    m_remainingTime = 0;
}

// Public interface
void Sterilizer::configure(float temperature, int durationSec) {
    config.targetTemperature = temperature;
    config.durationSeconds = durationSec;

    if (durationSec > 0) {
        m_remainingTime = durationSec;
        emit remainingTimeChanged();
    }

}

void Sterilizer::start() {
    if (config.targetTemperature <= 0.0f || config.durationSeconds <= 0) {
        triggerError("Not configured");
        return;
    }

    auto now = std::chrono::steady_clock::now();

    if (currentState == State::PAUSED) {
        const int elapsedBeforePause = config.durationSeconds - m_remainingTime;

        if (currentTemperature >= config.targetTemperature) {
            currentState = State::HOLD;
            heaterActive = false;
            timerActive = true;
            timerStart = now - std::chrono::seconds(elapsedBeforePause);
        } else {
            currentState = State::HEATING;
            heaterActive = true;
            timerActive = false;
            lastHeatUpdate = now;
        }

        emit stateChanged();
        emit remainingTimeChanged();

        cout << "Sterilizer resumed" << endl;
        return;
    }

    if (currentState != State::IDLE) return;

    currentState = State::HEATING;
    heaterActive = true;
    timerActive = false;
    lastHeatUpdate = now;
    m_remainingTime = config.durationSeconds;
    emit remainingTimeChanged();

    emit stateChanged();

    cout << "Sterilizer started" << endl;
}

void Sterilizer::pause() {
    if (currentState != State::HEATING && currentState != State::HOLD) return;

    if (currentState == State::HOLD && timerActive) {
        auto now = std::chrono::steady_clock::now();
        auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(now - timerStart).count();
        int remaining = config.durationSeconds - static_cast<int>(elapsed);
        if (remaining < 0) remaining = 0;

        if (remaining != m_remainingTime) {
            m_remainingTime = remaining;
            emit remainingTimeChanged();
        }
    }

    currentState = State::PAUSED;
    heaterActive = false;
    timerActive = false;

    emit stateChanged();

    cout << "Sterilizer paused" << endl;
    
}


void Sterilizer::update() {

    if (currentState == State::ERROR) {
        return;
    }
    
    auto now = std::chrono::steady_clock::now();
    
    // Heating State
    if (currentState == State::HEATING) {
        checkOverheat();

        // every 3s -> +1°C
        if (now - lastHeatUpdate >= std::chrono::seconds(3)) {
            currentTemperature += 1.0f;
            lastHeatUpdate = std::chrono::steady_clock::now();

            qDebug() << "temperatureChanged emitted" << currentTemperature;
            emit temperatureChanged(); 
        }

        // Temperature reached -> Holding temperature
        if (currentTemperature >= config.targetTemperature) {
            currentState = State::HOLD;
            heaterActive = false;
            timerActive = true;
            const int elapsedBeforeHold = config.durationSeconds - m_remainingTime;
            timerStart = now - std::chrono::seconds(elapsedBeforeHold);

            emit remainingTimeChanged();
            emit stateChanged();

        }
    }

    // Hold State
    if (currentState == State::HOLD && timerActive) {
        static constexpr double HOLD_HYSTERESIS = 1.0;

        if (currentTemperature <= config.targetTemperature - HOLD_HYSTERESIS) {
            heaterActive = true;
        }
        else if (currentTemperature >= config.targetTemperature + HOLD_HYSTERESIS) {
            heaterActive = false;
        }

        // Timer
        auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(now - timerStart).count();
        int remaining = config.durationSeconds - static_cast<int>(elapsed);
        if (remaining < 0) remaining = 0;

        // if (remaining != lastDisplayRemainingTime) {
        //     lastDisplayRemainingTime = remaining;

        //     emit remainingTimeChanged(); 
        // }
            std::cout << "remaining=" << remaining << std::endl;


        if (remaining != m_remainingTime) {
            m_remainingTime = remaining;
            emit remainingTimeChanged();
        }

        if (remaining <= 0) {
            currentState = State::FINISHED;
            timerActive = false;

            m_remainingTime = 0;
            emit remainingTimeChanged(); 
            emit stateChanged();

        }
    }
}



void Sterilizer::emergencyStop() {
    heaterActive = false; 
    timerActive = false;
    currentState = State::ERROR;

    emit stateChanged();
    emit errorOccurred("Emergency stop");

    cout << "!!! EMERGENCY STOP ACTIVATED !!!" << endl;
}

void Sterilizer::reset() {
    if (currentState != State::ERROR && currentState != State::FINISHED && currentState != State::PAUSED)
        return;

    heaterActive = false;
    timerActive = false;

    currentTemperature = 20.0f;
    currentState = State::IDLE;

    m_remainingTime = 0;

    emit temperatureChanged();
    emit remainingTimeChanged();
    emit stateChanged();

    cout << "System reset. Sterilizer is IDLE." << endl;
}

void Sterilizer::triggerError(const string& reason) {
    currentState = State::ERROR;
    heaterActive = false;
    timerActive = false;

    emit stateChanged();
    emit errorOccurred(QString::fromStdString(reason));

    cout << "ERROR: " << reason << endl;
}


void Sterilizer::checkOverheat() {
    // Absolut security
    if (currentTemperature >= MAX_TEMPERATURE) {
        triggerError("Absolute overheat");
        return;
    }

    // Relative security
    if (config.targetTemperature > 0.0f && currentTemperature >= config.targetTemperature + OVER_TARGET_MARGIN) {
        triggerError("Overheat beyond target");
        return;
    }
}


// Getters

float Sterilizer::temperature() const { return currentTemperature; }
State Sterilizer::state() const { return currentState; }
int Sterilizer::remainingTime() const { return m_remainingTime; }


// float Sterilizer::temperature() const {
//     return currentTemperature;
// }

// State Sterilizer::state() const {
//     return currentState;
// }

// int Sterilizer::remainingTime() const {
//     if (currentState != State::HOLD || !timerActive) {
//         return 0;
//     }

//     auto now = std::chrono::steady_clock::now();
//     auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(now - timerStart).count();

//     int remaining = config.durationSeconds - static_cast<int>(elapsed);
//     if (remaining < 0) remaining = 0;
//     return remaining;
// }

