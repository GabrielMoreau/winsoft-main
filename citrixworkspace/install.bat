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
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__


REM Silent install
CitrixWorkspaceApp-%softversion%.exe /silent /noreboot /AutoUpdateCheck=disabled /LOG="%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
