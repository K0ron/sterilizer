#include "sterilizer.h"
#include <iostream>
#include <iomanip>
using namespace std;


Sterilizer::Sterilizer() {
    currentTemperature = 20.0f; // Ambient temperature
    currentState = State::IDLE;
    heaterActive = false;
    timerActive = false;

    config.targetTemperature = 0.0f;
    config.durationSeconds = 0;

    lastDisplayRemainingTime = -1;
}

// Public interface
void Sterilizer::configure(float temperature, int durationSec) {
    config.targetTemperature = temperature;
    config.durationSeconds = durationSec;

}

void Sterilizer::start() {
    if (currentState == State::IDLE) {
        currentState = State::HEATING;
        heaterActive = true;
        timerActive = false;

        cout << "Sterilizer started" << endl;
    }
}

void Sterilizer::stop() {
    currentState = State::IDLE;
    heaterActive = false;
    timerActive = false; 

    cout << "Sterilizer stopped" << endl; 
}

void Sterilizer::update() {

    if (currentState == State::ERROR) {
        return;
    }
    checkOverheat();

    auto now = chrono::steady_clock::now();

    // Heating State
    if (currentState == State::HEATING) {

        // every 3s -> +1°C
        if (now - lastHeatUpdate >= chrono::seconds(3)) {
            currentTemperature += 1.0f;
            lastHeatUpdate = now;

            cout << "Heating... Temp = "
                 << currentTemperature << "°C" << endl;
        }

        // Temperature reached -> Holding temaperature
        if (currentTemperature >= config.targetTemperature) {
            currentState = State::HOLD; 
            heaterActive = false;
            timerActive = true; 
            timerStart = now;

            cout << "Target temperature reached. Holding..." << endl;
        }
    }

    // Hold State
    if (currentState == State::HOLD && timerActive) {
        // Regulation temperature
        static constexpr double HOLD_HYSTERESIS = 1.0;

        if (currentTemperature <= config.targetTemperature - HOLD_HYSTERESIS) {
            heaterActive = true;
        }
        else if (currentTemperature >= config.targetTemperature + HOLD_HYSTERESIS) {
            heaterActive = false;
        }

        // Timer
        auto elapsed = chrono::duration_cast<chrono::seconds>(now - timerStart).count();

        int remaining = config.durationSeconds - elapsed;

        if (remaining < 0) remaining = 0;

        if (remaining != lastDisplayRemainingTime) {
            lastDisplayRemainingTime = remaining;

            int hours = remaining / 3600;
            int minutes = (remaining % 3600) / 60;
            int seconds = remaining % 60;

              cout << "Holding... remaining time : "
                   << setw(2) << setfill('0') << hours << ":"
                   << setw(2) << setfill('0') << minutes << ":"
                   << setw(2) << setfill('0') << seconds 
                   << endl;
        }


        if (remaining <= 0) {
            currentState = State::FINISHED;
            timerActive = false;

            cout << "Sterilizer finished!" << endl;
        }
    }

}


void Sterilizer::emergencyStop() {
    heaterActive = false; 
    currentState = State::ERROR;

    cout << "!!! EMERGENCY STOP ACTIVATED !!!" << endl;
}

void Sterilizer::reset() {
    if (currentState != State::ERROR) {
        return;
    }

    heaterActive = false; 
    currentTemperature = 0.0;
    currentState = State::IDLE;

    cout << "System reset. Sterilizer is IDLE." << endl;
}

void Sterilizer::triggerError(const string& reason) {
    currentState = State::ERROR;
    heaterActive = false;

    cout << "ERROR: " << reason << endl;
}


void Sterilizer::checkOverheat() {
    // Absolut security
    if (currentTemperature >= MAX_TEMPERATURE) {
        triggerError("Absolute overheat");
        return;
    }

    // Relative security
    if (currentTemperature >= config.targetTemperature + OVER_TARGET_MARGIN) {
        triggerError("Overheat beyond target");
        return;
    }
}


// Getters
float Sterilizer::getTemperature() const {
    return currentTemperature;
}

State Sterilizer::getState() const {
    return currentState;
}

int Sterilizer::getRemainingTime() const {
    return 0;
}

