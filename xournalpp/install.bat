
REM
REM   XournalPP
REM

REM Name
SET softname=XournalPP

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript xournalpp-%softversion%-windows-setup-amd64.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /S /quiet -appvscriptrunnerparameters -wait -timeout=300


@ECHO [END] %date%-%time%
EXIT
