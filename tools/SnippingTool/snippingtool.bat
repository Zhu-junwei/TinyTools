@echo off

setlocal

rem ��ȡ����ϵͳ�汾��Ϣ
for /f "tokens=2 delims==" %%i in ('wmic os get version /value ^| findstr "="') do set OSVersion=%%i

rem �ж��Ƿ�Ϊ Windows 11����10��ͷ�����ڵ���10.0.22000��
if "%OSVersion:~0,2%"=="10" if "%OSVersion%" geq "10.0.22000" (
    start ms-screenclip:
) else (
    start snippingtool.exe
)

endlocal