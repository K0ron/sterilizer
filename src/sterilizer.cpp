#include "sterilizer.h"
#include <iostream>
using namespace std;


Sterilizer::Sterilizer() {
    currentTemperature = 20.0f; // Ambient temperature
    currentState = State::IDLE;
    heatingActive = false;
    timerActive = false;
}