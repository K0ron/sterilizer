# minimal CMake version required
cmake_minimum_required(VERSION 3.16)

# project name
project(Sterilizer)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)



# Qt6 quick (QML) + SVG support for QML Image/qrc assets
find_package(Qt6 COMPONENTS Quick Svg REQUIRED)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)


set(RESOURCES
resources.qrc
)

set(SOURCES
    src/main.cpp
    src/core/sterilizer.cpp
)

set(HEADERS
    src/core/sterilizer.h
)

qt_add_executable(Sterilizer
    ${SOURCES}
    ${HEADERS}
    ${RESOURCES}
)

target_include_directories(Sterilizer PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_link_libraries(Sterilizer PRIVATE
    Qt6::Quick
    Qt6::Svg
)

