@echo off
:start
echo.
echo.
echo.
echo ************************************************************************************
echo              Microsoft Activation Scripts (MAS)
echo  ��Դ Windows �� Office ������������ HWID��Ohook��KMS38
echo ������ KMS ��������Լ��߼������ų����ܡ�
echo.
echo ������https://massgrave.dev/
echo GitHub��https://github.com/massgravel/Microsoft-Activation-Scripts
echo.
echo.
echo.
echo.
echo  1.  PowerShell��ʽ��Windows 8 �����߰汾����������
echo  2.  ��ͳ��ʽ��Windows 7 �����߰汾��
echo  3.  �˳�   
echo *************************************************************************************
echo.
set /p option=���������ѡ��:
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
