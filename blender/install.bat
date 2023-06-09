REM @ECHO OFF

REM
REM   Blender
REM

REM Name
SET softname=Blender

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
msiexec /i "blender-%softversion%-windows-x64.msi" ALLUSERS=1 /qn /L*v "%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
