@echo off
echo ��ʼ��TinyTools���á���
set "username=%USERNAME%"
set "newdir=Data\%username%"
if not exist "%newdir%" mkdir "%newdir%"
taskkill /F /IM CLaunch.exe >nul 2>&1
xcopy "Data\default\*" "%newdir%\" /E /I /Y >nul 2>&1

echo ����TinyTools
start "" "ClAdmin.exe"
echo TinyTools�����У�˫������հ״�����ʹ��

ping -n 5 127.0.0.1>nul
exit