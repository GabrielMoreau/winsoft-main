@ECHO OFF

SET softname=BalenaEtcher
SET regkey=balena-etcher
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%softname%.lnk


REM Clean reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)

REM Remove Shortcut
IF EXIST "%shortcut%" DEL /F /Q "%shortcut%"

REM Auto Remove (last line)
IF EXIST "%ProgramFiles%\%regkey%" RMDIR /S /Q "%ProgramFiles%\%regkey%"
