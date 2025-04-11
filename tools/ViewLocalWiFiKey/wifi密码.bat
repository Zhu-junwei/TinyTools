@echo off & setlocal EnableDelayedExpansion
chcp 65001 >nul

echo Fetching saved WiFi accounts and passwords...
echo ==================================
for /f "tokens=2 delims=:" %%i in ('netsh wlan show profiles ^| findstr "All User Profile"') do (
    set "ssid=%%i"
    set "ssid=!ssid:~1!" 
    set "password="
    for /f "tokens=2 delims=:" %%j in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (
        set "password=%%j"
        set "password=!password:~1!" 
    )
    set "output=!ssid!                         " 
    echo !output:~0,25! !password!
)
echo ==================================
echo All WiFi passwords have been displayed.

pause