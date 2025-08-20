@echo off & chcp 65001>nul

title 微信多开工具 BetterWX-Mutex
set APP_PATH=%~dp0BetterWx-Mutex.exe
set STARTUP_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\BetterWx-Mutex.lnk
mode con cols=60 lines=25
:m
cls
echo. 
echo               微信多开工具 BetterWX-Mutex
echo.
echo   使用前请先关闭所有微信 
echo   使用前请先关闭所有微信 
echo   项目地址: https://github.com/afaa1991/BetterWX-UI
echo.   
echo   1. 开启多开 
echo   2. 关闭多开 
echo   3. 设置开机自启 
echo   4. 关闭开机自启 
echo   5. 退出 
echo. 
echo ==================================================
echo.
choice /C 12345 /M "请选择操作：" 
if errorlevel 5 exit
if %errorlevel% == 1 (
	start "" BetterWx-Mutex.exe
	echo 已开启微信多开 
	pause
) else if %errorlevel% == 2 (
	taskkill /F /IM BetterWx-Mutex.exe
	echo 已关闭微信多开 
	pause
) else if %errorlevel% == 3 (
    powershell -command ^
    "$s=(New-Object -COM WScript.Shell).CreateShortcut('%STARTUP_PATH%');" ^
    "$s.TargetPath='%APP_PATH%';" ^
    "$s.WorkingDirectory='%~dp0';" ^
    "$s.Save()"
    echo 已设置开机自启
    pause
) else if %errorlevel% == 4 (
    if exist "%STARTUP_PATH%" (
        del "%STARTUP_PATH%"
        echo 已关闭开机自启 
    ) else (
        echo 未找到开机自启项 
    )
    pause
)
goto :m