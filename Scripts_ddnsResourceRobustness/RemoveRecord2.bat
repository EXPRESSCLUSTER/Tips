@echo off
Powershell .\RemoveRecord.ps1
set ret=%ERRROR%
echo %0 ret: %ret%
exit %ret%
