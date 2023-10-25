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

SET softversion=__VERSION1__
SET softpatch=__PATCH__
SET softruntimever=__VERSION2__


Echo Silent install WindowsDesktop-Runtime
windowsdesktop-runtime-%softruntimever%-win-x64.exe /install /quiet /norestart

Echo Silent install %softname%
HandBrake-%softversion%-x86_64-Win_GUI.exe /S


ECHO END %date%-%time%
EXIT
