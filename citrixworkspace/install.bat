REM @ECHO OFF

REM
REM   CitrixWorkspace
REM

REM Name
SET softname=CitrixWorkspace

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
CitrixWorkspaceApp-%softversion%.exe /silent /noreboot /AutoUpdateCheck=disabled /LOG="%logdir%\%softname%-MSI.txt"


ECHO END %date%-%time%
EXIT
