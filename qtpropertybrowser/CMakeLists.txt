cmake_minimum_required(VERSION 3.27.5)

get_filename_component(current_dir "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
string(REPLACE " " "" current_dir "${current_dir}")
string(REPLACE "-" "_" current_dir "${current_dir}")

set(CMAKE_VERBOSE_MAKEFILE ON)
message(STATUS "CMake start \n\t directory name: ${current_dir}")

project("${current_dir}" VERSION 0.1 LANGUAGES CXX)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets Core Gui Core5Compat)
find_package(Qt${QT_VERSION_MAJOR} 6.6 REQUIRED COMPONENTS Widgets Core Gui Core5Compat)

file(GLOB_RECURSE ${PROJECT_NAME_UPPER}_H "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h")
file(GLOB_RECURSE ${PROJECT_NAME_UPPER}_CPP "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")

add_library(qtpropertybrowser STATIC
    ${${PROJECT_NAME_UPPER}_H}
    ${${PROJECT_NAME_UPPER}_CPP}
    src/qtpropertybrowser.qrc
)
target_include_directories(qtpropertybrowser PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)
target_link_libraries(qtpropertybrowser PUBLIC
    Qt6::Widgets
    Qt6::Core
    Qt6::Gui
    Qt6::Core5Compat
)

add_subdirectory(examples)
