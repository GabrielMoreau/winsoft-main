REM @ECHO OFF

REM
REM   Wireshark
REM

REM Name
SET softname=Wireshark

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

REM NPCAP
SET softversion2=91.5.1

REM Silent install
npcap-%softversion2%.exe /S

Wireshark-win64-%softversion%.exe /S


ECHO END %date%-%time%
EXIT
