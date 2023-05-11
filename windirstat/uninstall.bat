@ECHO OFF

SET softname=WinDirStat
SET regkey=windirstat

REM Uninstall
IF EXIST "%ProgramFiles(x86)%\WinDirStat\Uninstall.exe" (
  "%ProgramFiles(x86)%\WinDirStat\Uninstall.exe"
)

REM Clean reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)

REM Remove Shortcut
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%softname%.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%softname%.lnk"

REM Auto Remove (last line)
IF EXIST "%ProgramFiles(x86)%\WinDirStat" RMDIR /S /Q "%ProgramFiles(x86)%\WinDirStat"
