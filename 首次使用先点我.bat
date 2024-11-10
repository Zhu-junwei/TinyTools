@echo off
echo 初始化TinyTools配置……
set "username=%USERNAME%"
set "newdir=Data\%username%"
if not exist "%newdir%" mkdir "%newdir%"
taskkill /F /IM CLaunch.exe >nul 2>&1
xcopy "Data\default\*" "%newdir%\" /E /I /Y >nul 2>&1

echo 启动TinyTools
start "" "ClAdmin.exe"
echo TinyTools已运行，欢迎使用

ping -n 5 127.0.0.1>nul
exit
pause