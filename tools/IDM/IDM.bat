@echo off
chcp 65001 > nul
mode con cols=80 lines=25
title IDM下载激活管理 

:main_menu
cls
echo ********************************************************************************
echo                            IDM 激活工具 
echo.
echo   1.  方式一：使用 IDM_6.4x_Crack 激活（联网下载，有报毒的风险） 
echo   2.  方式二：使用本地 IAS.cmd 脚本激活（不推荐） 
echo.
echo   Q.  退出
echo ********************************************************************************
echo.

:: 正确写法，最多支持26个选项字符（大小写不同视为不同字符）  
choice /C 12Q /M "请选择操作（1/2/Q）：" 
if errorlevel 3 goto exit
if errorlevel 2 call IAS.cmd & goto main_menu
if errorlevel 1 start https://workupload.com/file/dgJcubkNwYU & goto main_menu

:exit
echo 已退出。 
exit
