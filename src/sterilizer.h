#ifndef STERILIZER_H
#define STERILIZER_H

#include <chrono>
using namespace std;


enum class State {
    IDLE,
    HEATING,
    HOLD,
    FINISHED,
    ERROR,
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
    void emergencyStop();
    void reset();
    void checkOverheat();
    void triggerError(const string&);

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
    chrono::steady_clock::time_point lastHeatUpdate;

    int lastDisplayRemainingTime;

    static constexpr double MAX_TEMPERATURE = 150.0;
    static constexpr double OVER_TARGET_MARGIN = 10.0;

};

#endif // STERILIZER_H






