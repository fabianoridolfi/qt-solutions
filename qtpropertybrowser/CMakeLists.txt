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


set(CUSTOM_LIB_DIR ${CMAKE_BINARY_DIR}/${PROJECT_NAME}_lib)
set(CUSTOM_BIN_DIR ${CMAKE_BINARY_DIR}/${PROJECT_NAME}_bin)
if(${CMAKE_GENERATOR} MATCHES "Visual Studio*")
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CUSTOM_LIB_DIR}/${CMAKE_SYSTEM_NAME})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CUSTOM_LIB_DIR}/${CMAKE_SYSTEM_NAME})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CUSTOM_BIN_DIR}/${CMAKE_SYSTEM_NAME})

    set(EXACT_OUTPUT_DIRECTORY ${CUSTOM_BIN_DIR}/${CMAKE_SYSTEM_NAME})
else()
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CUSTOM_LIB_DIR}/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CUSTOM_LIB_DIR}/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CUSTOM_BIN_DIR}/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE})

    set(EXACT_OUTPUT_DIRECTORY ${CUSTOM_BIN_DIR}/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE})
endif()


add_library(${PROJECT_NAME} STATIC
    ${${PROJECT_NAME_UPPER}_H}
    ${${PROJECT_NAME_UPPER}_CPP}
    src/qtpropertybrowser.qrc
)
target_include_directories(${PROJECT_NAME} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)
target_link_libraries(${PROJECT_NAME} PUBLIC
    Qt6::Widgets
    Qt6::Core
    Qt6::Gui
    Qt6::Core5Compat
)

message(STATUS "***** CMAKE_LIBRARY_OUTPUT_DIRECTORY: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} *****")

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
    ARCHIVE DESTINATION ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
    RUNTIME DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    # INCLUDES DESTINATION include
)

set(SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(DESTINATION_DIR "${CUSTOM_LIB_DIR}/include")

# 获取源文件夹中所有文件
file(GLOB SOURCE_FILES "${SOURCE_DIR}/*")

# 过滤出没有后缀名的文件
foreach(file ${SOURCE_FILES})
    get_filename_component(file_name "${file}" NAME)
    get_filename_component(file_extension "${file}" EXT)
    if(NOT IS_DIRECTORY "${file}" AND((NOT file_extension) OR (file_extension STREQUAL ".h")) )
        configure_file("${file}" "${DESTINATION_DIR}/${file_name}" COPYONLY)
        message(STATUS "${DESTINATION_DIR}/${file_name}")
    endif()
endforeach()

# install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include
#     DESTINATION ${CMAKE_INSTALL_LIBDIR}/include
# )

# install(EXPORT ${PROJECT_NAME}_targets
#     FILE ${PROJECT_NAME}_targets.cmake
#     NAMESPACE ${PROJECT_NAME}::${PROJECT_NAME}
#     DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
# )

add_subdirectory(examples)
