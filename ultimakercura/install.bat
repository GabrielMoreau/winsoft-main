
REM
REM   UltiMaker Cura
REM

REM Name
SET softname=UltiMakerCura

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
REM SET process=


REM ECHO Kill the current process
REM TASKKILL /T /F /IM %process%

ECHO Silent install %softname%
msiexec /i "UltiMaker-Cura-%softversion%-win64.msi" /qn /norestart /l*v "%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
