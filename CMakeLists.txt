cmake_minimum_required(VERSION 3.10)
project(QtQmlDemo VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# 查找Qt5
find_package(Qt5 5.12 REQUIRED COMPONENTS Core Quick Qml QuickControls2)

# 添加可执行文件
add_executable(QtQmlDemo
    src/main.cpp
    src/backend.cpp
    src/backend.h
    qml.qrc
)

# 链接Qt5库
target_link_libraries(QtQmlDemo
    Qt5::Core
    Qt5::Quick
    Qt5::Qml
    Qt5::QuickControls2
)

# 设置安装规则
install(TARGETS QtQmlDemo
    RUNTIME DESTINATION bin
)