REM @ECHO OFF

REM
REM   Inkscape
REM

REM Name
SET softname=Inkscape

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
msiexec /i "inkscape-%softversion%-x64.msi" ALLUSERS=1 /qn


ECHO END %date%-%time%
EXIT
