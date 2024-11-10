@echo off

REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /V DisplayVersion /T REG_DWORD /D 1 /F

taskkill /f /im explorer.exe
start explorer.exe