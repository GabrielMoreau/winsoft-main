@ECHO OFF

SET softname=HPImageAssist
SET regkey=%softname%
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\HP Image Assistant.lnk


REM Clean reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)

REM Remove Shortcut
IF EXIST "%shortcut%" DEL /F /Q "%shortcut%"

REM Auto Remove (last line)
IF EXIST "%ProgramFiles%\HP\HPIA" RMDIR /S /Q "%ProgramFiles%\HP\HPIA"
