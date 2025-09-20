@echo off
:: 编译测试程序脚本

echo Building Qt test program...

:: 设置Qt和MinGW路径（根据您的环境修改）
set QT_DIR=C:\Qt\5.15.2\mingw81_64
set MINGW_DIR=C:\Qt\Tools\mingw810_64
set PATH=%QT_DIR%\bin;%MINGW_DIR%\bin;%PATH%

:: 编译测试程序
echo Compiling test_qt.cpp...
g++ -o test_qt.exe test_qt.cpp ^
    -I%QT_DIR%\include ^
    -I%QT_DIR%\include\QtCore ^
    -I%QT_DIR%\include\QtGui ^
    -I%QT_DIR%\include\QtWidgets ^
    -L%QT_DIR%\lib ^
    -lQt5Core ^
    -lQt5Gui ^
    -lQt5Widgets ^
    -std=c++11

if %errorlevel% neq 0 (
    echo Compilation failed!
    pause
    exit /b 1
)

echo.
echo Compilation successful!
echo Running test program...
echo.

test_qt.exe

pause