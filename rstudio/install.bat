REM @ECHO OFF

REM
REM   RStudio
REM

REM Name
SET softname=RStudio

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
SET softversion2=91.5.1


ECHO Silent install R
R-%softversion2%-win.exe /VERYSILENT /NORESTART

ECHO Silent install %softname%
RStudio-%softversion%.exe /S


ECHO END %date%-%time%
EXIT
