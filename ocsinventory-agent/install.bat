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
OCS-Windows-Agent-Setup-%softversion%-x64.exe /S /NOSPLASH /UPGRADE /NP /DEBUG=1 /SSL=%ocsssl% /SERVER=%ocsserver% /PROXY_TYPE=0

REM Wait
ping 127.0.0.1 -n 30 > NUL

REM Install again
OCS-Windows-Agent-Setup-%softversion%-x64.exe /S /NOSPLASH /UPGRADE /NP /DEBUG=1 /SSL=%ocsssl% /SERVER=%ocsserver% /PROXY_TYPE=0 /NOW


ECHO END %date%-%time%
EXIT
