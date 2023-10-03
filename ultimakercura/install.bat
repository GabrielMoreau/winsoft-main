
REM
REM   UltiMaker Cura
REM

REM Name
SET softname=UltiMaker

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET softpatch=__PATCH__
SET process=


ECHO Kill the current process
TASKKILL /T /F /IM %process%

ECHO Silent install %softname%
msiexec /q /i "UltiMaker-Cura-%softversion%-win64.msi" /l*v "%logdir%\%softname%-MSI.log"

ECHO END %date%-%time%
EXIT
