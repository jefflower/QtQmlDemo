@echo off
:: 调试运行脚本 - 用于诊断程序启动问题

echo ===================================
echo Qt Application Debug Runner
echo ===================================
echo.

:: 设置环境变量以启用调试输出
set QT_DEBUG_PLUGINS=1
set QT_LOGGING_RULES=*.debug=true
set QML_IMPORT_TRACE=1
set QT_OPENGL=software

echo Environment variables set for debugging.
echo.

:: 检查可执行文件是否存在
if exist QtQmlDemo.exe (
    echo Found QtQmlDemo.exe
) else (
    echo ERROR: QtQmlDemo.exe not found!
    echo Please make sure you are running this script from the deploy directory.
    pause
    exit /b 1
)

:: 显示当前目录内容
echo.
echo Current directory contents:
dir /b

:: 检查关键DLL文件
echo.
echo Checking for critical DLLs:
if exist Qt5Core.dll echo [OK] Qt5Core.dll
if not exist Qt5Core.dll echo [MISSING] Qt5Core.dll

if exist Qt5Gui.dll echo [OK] Qt5Gui.dll
if not exist Qt5Gui.dll echo [MISSING] Qt5Gui.dll

if exist Qt5Qml.dll echo [OK] Qt5Qml.dll
if not exist Qt5Qml.dll echo [MISSING] Qt5Qml.dll

if exist Qt5QmlModels.dll echo [OK] Qt5QmlModels.dll
if not exist Qt5QmlModels.dll echo [MISSING] Qt5QmlModels.dll

if exist Qt5Quick.dll echo [OK] Qt5Quick.dll
if not exist Qt5Quick.dll echo [MISSING] Qt5Quick.dll

if exist Qt5Widgets.dll echo [OK] Qt5Widgets.dll
if not exist Qt5Widgets.dll echo [MISSING] Qt5Widgets.dll

:: 检查平台插件
echo.
echo Checking for platform plugin:
if exist platforms\qwindows.dll (
    echo [OK] platforms\qwindows.dll
) else (
    echo [MISSING] platforms\qwindows.dll
    echo This is critical - the application cannot start without this!
)

:: 检查QML目录
echo.
echo Checking QML directories:
if exist QtQuick.2 echo [OK] QtQuick.2 directory found
if not exist QtQuick.2 echo [WARNING] QtQuick.2 directory not found

if exist QtQuick echo [OK] QtQuick directory found
if not exist QtQuick echo [WARNING] QtQuick directory not found

:: 运行程序
echo.
echo ===================================
echo Starting application with debug output...
echo ===================================
echo.

QtQmlDemo.exe

echo.
echo ===================================
echo Application exited with code: %errorlevel%
echo ===================================

if %errorlevel% neq 0 (
    echo.
    echo The application did not exit normally.
    echo Common issues:
    echo 1. Missing DLL files - check the list above
    echo 2. Missing platforms\qwindows.dll - critical for Qt apps
    echo 3. QML files not embedded in resources
    echo 4. Incompatible Qt version or compiler
    echo.
    echo Try running with dependency walker to find missing DLLs.
)

echo.
pause