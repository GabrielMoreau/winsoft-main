
REM
REM   Nextcloud
REM

REM Name
SET softname=Nextcloud

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
ScriptRunner.exe -appvscript MsiExec.exe /i Nextcloud-%softversion%-x64.msi REBOOT=ReallySuppress /qn -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
