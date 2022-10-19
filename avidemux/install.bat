REM @ECHO OFF

REM
REM   Avidemux
REM

REM Name
SET softname=Avidemux

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
avidemux-%softversion%-win64.exe /S


ECHO END %date%-%time%

IF %ERRORLEVEL% EQU 1223 (
  REM 0 or 1223 are good exit code for Avidemux installer!
  EXIT 0
)
EXIT
