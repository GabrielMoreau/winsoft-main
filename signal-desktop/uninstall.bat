@ECHO OFF

SET softname=Signal-Desktop
SET regkey=7d96caee-06e6-597c-9f2f-c7bb2e0948b4
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Signal-Desktop.lnk


REM Clean reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)

REM Remove Shortcut
IF EXIST "%shortcut%" DEL /F /Q "%shortcut%"

REM Auto Remove (last line)
IF EXIST "%ProgramData%\signal-desktop" RMDIR /S /Q "%ProgramData%\signal-desktop"
