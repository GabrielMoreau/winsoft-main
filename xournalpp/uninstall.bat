@ECHO OFF

SET softname=XournalPP
SET regkey=Xournal++
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Xournal++.lnk


REM Clean reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)

REM Remove Shortcut
IF EXIST "%shortcut%" DEL /F /Q "%shortcut%"

REM Uninstall
IF EXIST "%ProgramFiles%\%regkey%\Uninstall.exe" Uninstall.exe /S

REM Auto Remove (last line)
IF EXIST "%ProgramFiles%\%regkey%" RMDIR /S /Q "%ProgramFiles%\%regkey%"
