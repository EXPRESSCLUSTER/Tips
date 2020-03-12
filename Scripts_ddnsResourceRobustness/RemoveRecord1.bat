@echo off
clpscrpc.exe .\RemoveRecord2.bat "%CLP_PATH%\bin\clpscrpl.exe"
set ret=%ERRROR%
echo %0 ret: %ret%
exit %ret%
