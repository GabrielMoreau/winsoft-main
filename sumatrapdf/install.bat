REM @ECHO OFF

REM
REM   SumatraPDF
REM

REM Name
SET softname=SumatraPDF

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
SumatraPDF-%softversion%-64-install.exe -s -all-users -with-filter


ECHO END %date%-%time%
EXIT
