
REM
REM   Hurukai-Agent
REM

REM Name
SET softname=Hurukai-Agent

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
ScriptRunner.exe -appvscript MsiExec.exe /i "agent-%softversion%_x64.msi" HOST=__HURUKAI_SERVER__ PORT=443 PROTO=https SRV_SIG_PUB=__HURUKAI_SIG__ ENROLLMENT_TOKEN=__HURUKAI_TOKEN__ /qn /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300

@ECHO [END] %date%-%time%
EXIT
