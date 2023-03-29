REM @ECHO OFF

REM
REM   Texmaker
REM

REM Name
SET softname=TexMaker

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=5.3.1
SET softpatch=1


ECHO Silent install
msiexec /i "Texmaker_%softversion%_Win_x64.msi"  /q


ECHO END %date%-%time%
EXIT
