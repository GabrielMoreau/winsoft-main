REM @ECHO OFF

REM
REM   PDFsam
REM

REM Name
SET softname=PDFsam

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
msiexec /i "pdfsam-%softversion%.msi" /qn /norestart CHECK_FOR_UPDATES=false CHECK_FOR_NEWS=false PLAY_SOUNDS=false DONATE_NOTIFICATION=false SKIPTHANKSPAGE=Yes PREMIUM_MODULES=false /L*v "%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
