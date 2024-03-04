
REM
REM   Audacity
REM

REM Name
SET softname=Audacity

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Silent install %softname%
ScriptRunner.exe -appvscript audacity-win-%softversion%-x64.exe /TASKS="!desktopicon,!resetprefs" /VERYSILENT /NORESTART /LOG="%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
