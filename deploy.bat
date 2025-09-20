@echo off
:: Windows部署脚本 - 用于打包Qt应用程序及其依赖

echo ===================================
echo Qt Application Deployment Script
echo ===================================
echo.

:: 设置Qt和编译器路径（根据您的环境修改这些路径）
set QT_DIR=C:\Qt\5.15.2\mingw81_64
set MINGW_DIR=C:\Qt\Tools\mingw810_64
set PATH=%QT_DIR%\bin;%MINGW_DIR%\bin;%PATH%

:: 检查Qt路径是否存在
if not exist "%QT_DIR%\bin\windeployqt.exe" (
    echo ERROR: windeployqt.exe not found at %QT_DIR%\bin\
    echo Please set QT_DIR to your Qt installation path
    pause
    exit /b 1
)

:: 创建部署目录
if exist deploy rmdir /s /q deploy
mkdir deploy

:: 复制可执行文件
if not exist build\Release\QtQmlDemo.exe (
    if not exist build\QtQmlDemo.exe (
        echo ERROR: QtQmlDemo.exe not found in build directory
        echo Please build the project first
        pause
        exit /b 1
    )
    copy build\QtQmlDemo.exe deploy\
) else (
    copy build\Release\QtQmlDemo.exe deploy\
)

echo.
echo Deploying Qt dependencies...
:: 使用windeployqt部署Qt依赖
%QT_DIR%\bin\windeployqt.exe ^
    --qmldir qml ^
    --quick ^
    --no-translations ^
    --no-system-d3d-compiler ^
    --no-opengl-sw ^
    --no-virtualkeyboard ^
    --no-angle ^
    --release ^
    deploy\QtQmlDemo.exe

if %errorlevel% neq 0 (
    echo ERROR: windeployqt failed
    pause
    exit /b 1
)

echo.
echo Copying MinGW runtime libraries...
:: 复制MinGW运行时库
copy "%MINGW_DIR%\bin\libgcc_s_seh-1.dll" deploy\ >nul 2>&1
copy "%MINGW_DIR%\bin\libstdc++-6.dll" deploy\ >nul 2>&1
copy "%MINGW_DIR%\bin\libwinpthread-1.dll" deploy\ >nul 2>&1

:: 手动复制所有必需的Qt库（确保完整性）
echo.
echo Copying essential Qt libraries...
copy "%QT_DIR%\bin\Qt5Core.dll" deploy\ >nul 2>&1
copy "%QT_DIR%\bin\Qt5Gui.dll" deploy\ >nul 2>&1
copy "%QT_DIR%\bin\Qt5Qml.dll" deploy\ >nul 2>&1
copy "%QT_DIR%\bin\Qt5QmlModels.dll" deploy\ >nul 2>&1
copy "%QT_DIR%\bin\Qt5QmlWorkerScript.dll" deploy\ >nul 2>&1
copy "%QT_DIR%\bin\Qt5Quick.dll" deploy\ >nul 2>&1
copy "%QT_DIR%\bin\Qt5QuickControls2.dll" deploy\ >nul 2>&1
copy "%QT_DIR%\bin\Qt5QuickTemplates2.dll" deploy\ >nul 2>&1
copy "%QT_DIR%\bin\Qt5QuickShapes.dll" deploy\ >nul 2>&1
copy "%QT_DIR%\bin\Qt5Network.dll" deploy\ >nul 2>&1
copy "%QT_DIR%\bin\Qt5Widgets.dll" deploy\ >nul 2>&1
copy "%QT_DIR%\bin\Qt5Svg.dll" deploy\ >nul 2>&1

:: 复制Qt插件
echo Copying Qt plugins...
if not exist deploy\platforms mkdir deploy\platforms
copy "%QT_DIR%\plugins\platforms\qwindows.dll" deploy\platforms\ >nul 2>&1

if not exist deploy\imageformats mkdir deploy\imageformats
copy "%QT_DIR%\plugins\imageformats\*.dll" deploy\imageformats\ >nul 2>&1

if not exist deploy\styles mkdir deploy\styles
copy "%QT_DIR%\plugins\styles\qwindowsvistastyle.dll" deploy\styles\ >nul 2>&1

:: 复制QML模块
echo Copying QML modules...
if not exist deploy\QtQuick.2 mkdir deploy\QtQuick.2
xcopy /E /I /Y "%QT_DIR%\qml\QtQuick.2" deploy\QtQuick.2 >nul 2>&1

if not exist deploy\QtQuick mkdir deploy\QtQuick
xcopy /E /I /Y "%QT_DIR%\qml\QtQuick" deploy\QtQuick >nul 2>&1

if not exist deploy\QtQml mkdir deploy\QtQml
xcopy /E /I /Y "%QT_DIR%\qml\QtQml" deploy\QtQml >nul 2>&1

if not exist deploy\Qt mkdir deploy\Qt
xcopy /E /I /Y "%QT_DIR%\qml\Qt" deploy\Qt >nul 2>&1

:: 验证关键DLL
echo.
echo Verifying critical DLLs...
set MISSING_DLL=0

for %%f in (Qt5Core.dll Qt5Gui.dll Qt5Qml.dll Qt5QmlModels.dll Qt5Quick.dll Qt5QuickControls2.dll) do (
    if exist deploy\%%f (
        echo [OK] %%f
    ) else (
        echo [MISSING] %%f
        set MISSING_DLL=1
    )
)

if %MISSING_DLL% equ 1 (
    echo.
    echo WARNING: Some DLL files are missing!
    echo Please check your Qt installation path.
)

:: 创建Windows 7兼容性启动脚本
echo.
echo Creating Windows 7 compatibility launcher...
echo @echo off > deploy\QtQmlDemo_Win7.bat
echo :: Windows 7 compatibility launcher >> deploy\QtQmlDemo_Win7.bat
echo set QT_OPENGL=software >> deploy\QtQmlDemo_Win7.bat
echo start QtQmlDemo.exe %%* >> deploy\QtQmlDemo_Win7.bat

:: 复制QML文件（作为备用方案）
echo Copying QML files as backup...
if not exist deploy\qml mkdir deploy\qml
copy qml\*.qml deploy\qml\ >nul 2>&1

:: 复制资源文件
if exist resources\logo.png (
    if not exist deploy\resources mkdir deploy\resources
    copy resources\logo.png deploy\resources\ >nul 2>&1
)

:: 显示部署结果
echo.
echo ===================================
echo Deployment Complete!
echo ===================================
echo.
echo Deployed files:
dir deploy\*.exe deploy\*.dll /b | find /c /v ""
echo file(s) deployed to deploy\
echo.
echo To run on Windows 7, use: QtQmlDemo_Win7.bat
echo.

pause