@echo off

setlocal

rem 获取操作系统版本信息
for /f "tokens=2 delims==" %%i in ('wmic os get version /value ^| findstr "="') do set OSVersion=%%i

rem 判断是否为 Windows 11（以10开头并大于等于10.0.22000）
if "%OSVersion:~0,2%"=="10" if "%OSVersion%" geq "10.0.22000" (
    start ms-screenclip:
) else (
    start snippingtool.exe
)

endlocal