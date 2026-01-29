#ifndef STERILIZER_H
#define STERILIZER_H

#include <chrono>
using namespace std;


enum class State {
    IDLE,
    HEATING,
    HOLD,
    FINISHED
};

struct Configuration {
    float targetTemperature;
    int durationSeconds; 
};

// Main class representing the sterilizer device
class Sterilizer {
public: 
    Sterilizer();

    //Public interface
    void configure(float temperature, int durationSec);
    void start();
    void stop();
    void update(); // Called in loop to simulate heating

    //Getters
    float getTemperature() const;
    State getState() const; 
    int getRemainingTime() const;

private: 
    Configuration config; 
    State currentState;

    float currentTemperature;
    bool heaterActive; 

    bool timerActive;
    chrono::steady_clock::time_point timerStart;

};

#endif // STERILIZER_H






