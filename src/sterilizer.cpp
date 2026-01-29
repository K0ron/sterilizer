#include "sterilizer.h"
#include <iostream>
using namespace std;


Sterilizer::Sterilizer() {
    currentTemperature = 20.0f; // Ambient temperature
    currentState = State::IDLE;
    heaterActive = false;
    timerActive = false;

    config.targetTemperature = 0.0f;
    config.durationSeconds = 0;
}

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
    // vide pour le moment
}

float Sterilizer::getTemperature() const {
    return currentTemperature;
}

State Sterilizer::getState() const {
    return currentState;
}

int Sterilizer::getRemainingTime() const {
    return 0;
}

