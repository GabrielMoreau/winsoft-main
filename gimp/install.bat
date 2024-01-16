REM @ECHO OFF

REM
REM   Gimp
REM

REM Name
SET softname=Gimp

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__


REM Silent install
gimp-%softversion%-setup.exe /VERYSILENT /NORESTART /ALLUSERS /LOG="%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
