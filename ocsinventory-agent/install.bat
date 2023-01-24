REM @ECHO OFF

REM
REM   OCSInventory-Agent
REM

REM Name
SET softname=OCSInventory-Agent

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=91.5.1
SET softpatch=1
SET ocsserver=ocs-server.example.com
SET ocsssl=1

REM Silent install
OCS-Windows-Agent-Setup-%softversion%-x64.exe /S /NOSPLASH /UPGRADE /NP /DEBUG /NOW /SSL=%ocsssl% /DEBUG=1 /SERVER=%ocsserver%


ECHO END %date%-%time%
EXIT
