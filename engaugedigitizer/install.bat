REM @ECHO OFF

REM
REM   EngaugeDigitizer
REM

REM Name
SET softname=EngaugeDigitizer

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
msiexec /i "digit-exe-windows10-64-bit-installer-%softversion%.msi" /qn /norestart /L*v "%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
