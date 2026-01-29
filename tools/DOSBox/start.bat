@ECHO OFF & chcp 65001>nul
setlocal enabledelayedexpansion
cd DOSBOX

:: 检查是否传入了参数
IF "%1"=="" (
    :: 如果没有参数，执行默认命令
    start dosbox
    EXIT /B 0
)

:: 构建配置文件路径
SET CONFIG_FILE=..\config\%1.conf

:: 检查配置文件是否存在
IF NOT EXIST "%CONFIG_FILE%" (
    ECHO 配置文件 %CONFIG_FILE% 不存在。
    EXIT /B 1
)

set /p option=是否打开dosbox快捷键说明[y/N]:
if /i "%option%"=="y"  call :open_shortcut
if "%1"=="SABA" (
	set /p "saba_option=是否打开俄罗斯方块游戏说明[y/N]:" 
	if /i "!saba_option!"=="y" call :open_saba_readme
)
call :start_dosbox
exit

:open_shortcut
START notepad "..\dosbox快捷键.txt"
exit /b

:open_saba_readme
START notepad "..\software\saba\README.txt"
exit /b

:start_dosbox
:: 执行 DOSBox 并使用指定的配置文件
start dosbox -CONF "%CONFIG_FILE%" -NOCONSOLE