@ECHO OFF

SET softname=Avidemux
SET softversionshort=__VERSIONSHORT__
SET regkey={0694d9fc-951c-4992-85e9-23eb6d1a8082}
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Avidemux.lnk


REM Clean reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)

REM Remove Shortcut
IF EXIST "%shortcut%" DEL /F /Q "%shortcut%"

REM Auto Remove (last line)
IF EXIST "%ProgramFiles%\Avidemux %softversionshort% VC++ 64bits" RMDIR /S /Q "%ProgramFiles%\Avidemux %softversionshort% VC++ 64bits"
