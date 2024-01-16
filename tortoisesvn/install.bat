REM @ECHO OFF

REM
REM   TortoiseSVN
REM

REM Name
SET softname=TortoiseSVN

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
msiexec /i "TortoiseSVN-%softversion%-x64.msi" /qn /norestart /L*v "%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
