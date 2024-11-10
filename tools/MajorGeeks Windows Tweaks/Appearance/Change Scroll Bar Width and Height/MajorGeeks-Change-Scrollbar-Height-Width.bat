::  MajorGeeks Change Scroll Bar Width and Height 1.0
::  Special Credit to  Alomware.com 

@echo off
set /p input=Enter scroll bar WIDTH pixel size (default is 17): 
set /a width=-15*%input%
set /p input=Enter scroll bar HEIGHT pixel size (default is 17): 
set /a height=-15*%input%
set /p yn=Applying the changes will need you to log off. Is that okay (y/n): 
if "%yn%" neq "y" goto abort
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v ScrollWidth /t reg_sz /d %width% /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v ScrollHeight /t reg_sz /d %height% /f
shutdown -l -f
:abort
exit
