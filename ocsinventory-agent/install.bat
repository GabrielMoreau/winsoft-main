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

REM Stop OCS service
SET servicename=OCS Inventory Service
SC QUERYEX "%servicename%" | FIND "STATE" | FIND "RUNNING" >NUL && (
  ECHO %servicename% is running, stop it
  NET STOP  "OCS Inventory Service"
)
SC QUERYEX "%servicename%" | FIND "STATE"

REM Kill process
TASKKILL /T /F /IM OcsSystray.exe
TASKKILL /T /F /IM OcsService.exe
TASKKILL /T /F /IM OcsInventory.exe
TASKKILL /T /F /IM download.exe
TASKKILL /T /F /IM inst32.exe


REM Install again
OCS-Windows-Agent-Setup-%softversion%-x64.exe /S /NOSPLASH /UPGRADE /NP /DEBUG=1 /SSL=%ocsssl% /SERVER=%ocsserver% /PROXY_TYPE=0 /NOW


REM Start service
REM NET START  "OCS Inventory Service"


ECHO END %date%-%time%
EXIT
