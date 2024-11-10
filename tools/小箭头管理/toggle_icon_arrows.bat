@echo off
mode con: cols=80 lines=20
title 桌面图标小箭头管理工具

:: 请求管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 请求管理员权限...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /b

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

:start
cls

:: 获取系统版本号
for /f "tokens=4 delims=. " %%i in ('ver') do set ver=%%i

:: 判断是否为Windows 11
if "%ver%"=="22000" (
    set isWin11=true
) else (
    set isWin11=false
)

echo 请选择要执行的操作：
echo 1. 隐藏桌面图标小箭头
echo 2. 显示桌面图标小箭头
echo 3. 退出

set /p choice="请输入选项编号（1-3）："

if "%choice%"=="1" (
    if "%isWin11%"=="true" (
        echo 正在隐藏Win11桌面图标小箭头...
        reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /d "%systemroot%\system32\imageres.dll,197" /t reg_sz /f
        taskkill /f /im explorer.exe
        attrib -s -r -h "%userprofile%\AppData\Local\iconcache.db"
        del "%userprofile%\AppData\Local\iconcache.db" /f /q
        start explorer
    ) else (
        echo 正在隐藏其他Windows版本桌面图标小箭头...
        reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /d "%systemroot%\system32\imageres.dll,197" /t reg_sz /f
        taskkill /f /im explorer.exe
        start explorer
    )
    goto start
) else if "%choice%"=="2" (
    echo 正在显示桌面图标小箭头...
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /f
    taskkill /f /im explorer.exe
    start explorer
    goto start
) else if "%choice%"=="3" (
    echo 退出程序...
    exit
) else (
    echo 无效的选项，请重新运行脚本并输入正确的选项编号。
    goto start
)