REM @ECHO OFF

REM
REM   Ultracopier
REM

REM Name
SET softname=Ultracopier

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET softpatch=__PATCH__


ECHO Remove old version (not clean but work's with /S flag)
IF EXIST "%ProgramFiles%\Ultracopier" (
  RMDIR /S /Q "%ProgramFiles%\Ultracopier"
)
IF EXIST "%ProgramFiles(x86)%\Ultracopier" (
  RMDIR /S /Q "%ProgramFiles(x86)%\Ultracopier"
)
REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Ultracopier"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Ultracopier" /F
)
REG QUERY "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Ultracopier"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Ultracopier" /F
)

ECHO Silent install %softname%
ultracopier-windows-x86_64-%softversion%-setup.exe /S


ECHO END %date%-%time%
EXIT
