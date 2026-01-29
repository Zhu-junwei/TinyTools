@echo off & chcp 65001 > nul

title IDM下载激活管理 
:main_menu
cls
echo ********************************************************************************
echo                            IDM 激活工具 
echo.
echo   1. 使用 IDM_6.4x_Crack 激活（联网下载，如报毒请关闭杀毒软件） 
echo   2. 使用本地 IAS.cmd 脚本激活（不稳定，不推荐） 
echo.
echo   3. 退出
echo ********************************************************************************
echo.
choice /C 123 /M "请选择操作：" 
if errorlevel 3 exit
if errorlevel 2 call IAS.cmd & goto main_menu
if errorlevel 1 call :open_download_url & goto main_menu

:open_download_url
echo 正在获取下载地址... 
set "URL_SOURCE=https://idm.ckk.ir/"
set "Download_URL=https://workupload.com/file/dgJcubkNwYU"
for /f "tokens=2 delims=<>" %%a in ('curl.exe -s "%URL_SOURCE%" ^| findstr /i "Download_URL"') do (
    set "Download_URL=%%a"
)
start "" "%Download_URL%"
exit /b
