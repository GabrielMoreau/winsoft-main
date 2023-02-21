REM @ECHO OFF

REM
REM   HandBrake
REM

REM Name
SET softname=HandBrake

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
SET softruntimever=6.5.1


REM Silent install
windowsdesktop-runtime-%softruntimever%-win-x64.exe /install /quiet /norestart

HandBrake-%softversion%-x86_64-Win_GUI.exe /S


ECHO END %date%-%time%
EXIT
