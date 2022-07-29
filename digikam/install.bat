REM @ECHO OFF

REM
REM   Digikam
REM

REM Name
SET softname=Digikam

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


REM Silent install
digiKam-%softversion%-Win64.exe /S


ECHO END %date%-%time%
EXIT
