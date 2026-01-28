# minimal CMake version required
cmake_minimum_required(VERSION 3.10)

# project name
project(Sterilizer)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)


# Found source files
include_directories(src)

# add all cpp files in src directory
file(GLOB SOURCES "src/*.cpp")

#create executable
add_executable(Sterilizer ${SOURCES})

