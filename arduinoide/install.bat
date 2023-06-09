REM @ECHO OFF

REM
REM   ArduinoIDE
REM

REM Name
SET softname=ArduinoIDE

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
msiexec /i "arduino-ide_%softversion%_Windows_64bit.msi" ALLUSERS=1 /qn /L*v "%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
