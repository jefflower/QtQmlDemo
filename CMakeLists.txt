cmake_minimum_required(VERSION 3.16)
project(QtQmlDemo VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# 查找Qt5
# 设置Qt5查找路径（如果需要）
if(DEFINED ENV{Qt5_DIR})
    set(Qt5_DIR $ENV{Qt5_DIR})
endif()

find_package(Qt5 5.12 REQUIRED COMPONENTS Core Quick Qml Widgets Sql Network)
find_package(Qt5QuickControls2 REQUIRED)

# 添加可执行文件
add_executable(QtQmlDemo
    src/main.cpp
    src/backend.cpp
    src/backend.h
    src/databasemanager.cpp
    src/databasemanager.h
    src/httpclient.cpp
    src/httpclient.h
    src/medicaldataprocessor.cpp
    src/medicaldataprocessor.h
    qml.qrc
)

# 链接Qt5库
target_link_libraries(QtQmlDemo
    Qt5::Core
    Qt5::Quick
    Qt5::Qml
    Qt5::QuickControls2
    Qt5::Widgets
    Qt5::Sql
    Qt5::Network
)

# 设置安装规则
install(TARGETS QtQmlDemo
    RUNTIME DESTINATION bin
)