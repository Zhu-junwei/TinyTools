@echo off
mode con: cols=80 lines=20
title ����ͼ��С��ͷ������

:: �������ԱȨ��
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo �������ԱȨ��...
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

:: ��ȡϵͳ�汾��
for /f "tokens=4 delims=. " %%i in ('ver') do set ver=%%i

:: �ж��Ƿ�ΪWindows 11
if "%ver%"=="22000" (
    set isWin11=true
) else (
    set isWin11=false
)

echo ��ѡ��Ҫִ�еĲ�����
echo 1. ��������ͼ��С��ͷ
echo 2. ��ʾ����ͼ��С��ͷ
echo 3. �˳�

set /p choice="������ѡ���ţ�1-3����"

if "%choice%"=="1" (
    if "%isWin11%"=="true" (
        echo ��������Win11����ͼ��С��ͷ...
        reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /d "%systemroot%\system32\imageres.dll,197" /t reg_sz /f
        taskkill /f /im explorer.exe
        attrib -s -r -h "%userprofile%\AppData\Local\iconcache.db"
        del "%userprofile%\AppData\Local\iconcache.db" /f /q
        start explorer
    ) else (
        echo ������������Windows�汾����ͼ��С��ͷ...
        reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /d "%systemroot%\system32\imageres.dll,197" /t reg_sz /f
        taskkill /f /im explorer.exe
        start explorer
    )
    goto start
) else if "%choice%"=="2" (
    echo ������ʾ����ͼ��С��ͷ...
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /f
    taskkill /f /im explorer.exe
    start explorer
    goto start
) else if "%choice%"=="3" (
    echo �˳�����...
    exit
) else (
    echo ��Ч��ѡ����������нű���������ȷ��ѡ���š�
    goto start
)