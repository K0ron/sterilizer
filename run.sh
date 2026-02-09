#!/bin/bash
set -e

mkdir -p build
cd build

cmake .. -DCMAKE_PREFIX_PATH=/opt/homebrew/opt/qt
cmake --build .

./Sterilizer
