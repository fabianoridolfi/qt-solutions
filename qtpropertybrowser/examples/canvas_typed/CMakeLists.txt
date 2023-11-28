
cmake_minimum_required(VERSION 3.14)

project(canvas_typed
	LANGUAGES CXX
	VERSION 0.1
)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS 
    Widgets 
    Core 
    Gui
)

add_executable(canvas_typed WIN32
    main.cpp
    mainwindow.cpp
    qtcanvas.cpp

    qtcanvas.h 
    mainwindow.h
)
target_include_directories(canvas_typed PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ../../src
)
target_link_libraries(canvas_typed PRIVATE
    qtpropertybrowser
    Qt6::Widgets
    Qt6::Core
    Qt6::Gui
)
