REM @ECHO OFF

REM
REM   XournalPP
REM

REM Name
SET softname=XournalPP

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
xournalpp-%softversion%-windows.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /S /quiet


ECHO END %date%-%time%
EXIT
