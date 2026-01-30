#include <sterilizer.h>
#include <thread>
#include <iostream>
using namespace std;

int main() {

    float temperature; 
    int hours;
    int minutes;

    cout << "==== Sterilizer configuration ====" << endl;

    cout << "Target Temperature (°C): ";
    cin >> temperature; 

    cout << "Duration hours: ";
    cin >> hours;

    cout << "Duration minutes: ";
    cin >> minutes;


    //Minimal security checks
    if (temperature <= 0 || hours < 0 || minutes < 0 || minutes >= 60) {
        cout << "Invalid configuration." << endl;
        return 1;
    } 

    int durationSeconds = (hours * 3600) + (minutes * 60);

    if (durationSeconds <= 0) {
        cout << "Duration must be greater than 0." << endl;
        return 1;
    }

    
    Sterilizer sterilizer;

    sterilizer.configure(temperature, durationSeconds);
    sterilizer.start();
    // this_thread::sleep_for(chrono::seconds(3));
    // sterilizer.emergencyStop();
    // this_thread::sleep_for(chrono::seconds(2));
    // sterilizer.reset();


    while (true) {
        sterilizer.update();
        this_thread::sleep_for(chrono::milliseconds(100));

        if (sterilizer.getState() == State::FINISHED) {
            break;
        }
    }
    
    return 0;
}