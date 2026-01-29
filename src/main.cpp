#include <sterilizer.h>
#include <iostream>
using namespace std;

int main() {
    Sterilizer sterilizer;

    sterilizer.configure(105.0f, 3 * 60 * 60);
    sterilizer.start();
    cout << "Sterilizer running..." << endl;
    return 0;
}