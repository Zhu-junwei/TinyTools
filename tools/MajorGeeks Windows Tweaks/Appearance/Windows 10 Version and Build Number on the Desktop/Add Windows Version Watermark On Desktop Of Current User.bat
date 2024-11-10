@echo off

REG ADD "HKCU\Control Panel\Desktop" /V PaintDesktopVersion /T REG_DWORD /D 1 /F

taskkill /f /im explorer.exe
start explorer.exe