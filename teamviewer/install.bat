REM @ECHO OFF

REM
REM   TeamViewer
REM

REM Name
SET softname=TeamViewer

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=2.6.11
SET softpatch=1


REM Silent install
REM TeamViewer_Setup.exe /S
TeamViewer-%softversion%-Setup-x64.exe /S


REM Disable auto update
REG ADD "HKLM\SOFTWARE\WOW6432Node\TeamViewer" /v AutoUpdateMode /t REG_DWORD /d 3 /f
REG ADD "HKLM\SOFTWARE\WOW6432Node\TeamViewer" /v UpdateCheckInterval /t REG_DWORD /d 2 /f
cmd /c "net stop "TeamViewer" && net start "TeamViewer""


ECHO END %date%-%time%
EXIT
