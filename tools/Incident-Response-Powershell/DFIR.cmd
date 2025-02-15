@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Bert-JanP/Incident-Response-Powershell/main/DFIR-Script.ps1 | iex"
pause