@ECHO OFF

SET softname=Picocrypt
SET regkey=EvanSu.Picocrypt_is1

REM Clean reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)

REM Remove Shortcut
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%softname%.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%softname%.lnk"

REM Clean Uninstall
IF EXIST "%ProgramFiles%\Picocrypt\unins000.exe" "%ProgramFiles%\Picocrypt\unins000.exe" /VERYSILENT /NORESTART

REM Auto Remove (last line)
IF EXIST "%ProgramFiles%\Picocrypt" RMDIR /S /Q "%ProgramFiles%\Picocrypt"
