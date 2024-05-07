
REM
REM   CitrixWorkspace
REM

REM Name
SET softname=CitrixWorkspace

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
ScriptRunner.exe -appvscript CitrixWorkspaceApp-%softversion%.exe /silent /noreboot /AutoUpdateCheck=disabled /LOG="%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=600


ECHO END %date%-%time%
EXIT
