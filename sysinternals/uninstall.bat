@ECHO OFF

SET softname=SysinternalsSuite
SET regkey=Sysinternals


REM Clean reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)

REM Auto Remove (last line)
IF EXIST "%ProgramFiles%\%regkey%" RMDIR /S /Q "%ProgramFiles%\%regkey%"
