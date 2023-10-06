@ECHO OFF

SET softname=IdeaMaker
SET regkey=ideaMaker


REM Clean reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)

REM Clean Uninstall
IF EXIST "%ProgramFiles%\Raise3D\ideaMaker\" "%ProgramFiles%\Raise3D\ideaMaker\uninstall.exe"

REM Auto Remove (last line)
IF EXIST "%ProgramFiles%\Raise3D\ideaMaker" RMDIR /S /Q "%ProgramFiles%\Raise3D\ideaMaker"
