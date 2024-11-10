@echo off
:start
echo.
echo.
echo.
echo ************************************************************************************
echo              Microsoft Activation Scripts (MAS)
echo  开源 Windows 和 Office 激活器，具有 HWID、Ohook、KMS38
echo 和在线 KMS 激活方法，以及高级故障排除功能。
echo.
echo 官网：https://massgrave.dev/
echo GitHub：https://github.com/massgravel/Microsoft-Activation-Scripts
echo.
echo.
echo.
echo.
echo  1.  PowerShell方式（Windows 8 及更高版本，需联网）
echo  2.  传统方式（Windows 7 及更高版本）
echo  3.  退出   
echo *************************************************************************************
echo.
set /p option=请输入你的选择:
if "%option%"=="1" (
    start powershell -Command "irm https://get.activated.win | iex"
) else if "%option%"=="2" (
    call "MAS_AIO.cmd"
) else if "%option%"=="3" (
    exit
)else (
    cls
    set option=null
    goto start
)
