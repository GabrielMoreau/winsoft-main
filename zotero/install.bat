REM @ECHO OFF

REM
REM   Zotero
REM

REM Name
SET softname=Zotero

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=91.5.1
SET softpatch=1


REM Silent install
Zotero-%softversion%_setup.exe /S


ECHO END %date%-%time%
EXIT
