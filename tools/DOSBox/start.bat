@ECHO OFF
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

:: 执行 DOSBox 并使用指定的配置文件
start dosbox -CONF "%CONFIG_FILE%" -NOCONSOLE