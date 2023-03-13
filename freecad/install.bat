REM @ECHO OFF

REM
REM   FreeCAD
REM

REM Name
SET softname=FreeCAD

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


ECHO Silent install %softname%
FreeCAD-WIN-x64-installer-%softversion%.exe /S


ECHO END %date%-%time%
EXIT
