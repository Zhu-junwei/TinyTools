@ECHO OFF
cd DOSBOX

:: 检查是否传入了配置文件参数
IF "%1"=="" (
    ECHO 必须指定配置文件参数。
    EXIT /B 1
)

:: 检查是否传入了游戏文件参数
IF "%2"=="" (
    ECHO 必须指定游戏文件参数。
    EXIT /B 1
)

:: 配置文件路径
SET CONFIG_FILE=..\config\%1.conf

:: 检查配置文件是否存在
IF NOT EXIST "%CONFIG_FILE%" (
    ECHO 配置文件 %CONFIG_FILE% 不存在。
    EXIT /B 1
)

:: 动态生成临时配置文件，确保路径存在
SET TEMP_CONFIG_FILE=..\config\temp\temp_nesticle.conf
IF NOT EXIST ..\config\temp\ (
    MKDIR ..\config\temp\
)
COPY "%CONFIG_FILE%" "%TEMP_CONFIG_FILE%" > NUL

:: 向临时配置文件追加启动游戏的指令
ECHO MOUNT D: ..\software\nesticle >> "%TEMP_CONFIG_FILE%"
ECHO D: >> "%TEMP_CONFIG_FILE%"
ECHO NESTICLE.EXE %2 >> "%TEMP_CONFIG_FILE%"
ECHO EXIT >> "%TEMP_CONFIG_FILE%"

:: 运行 DOSBox 并使用动态生成的配置文件
start dosbox -CONF "%TEMP_CONFIG_FILE%" -NOCONSOLE
