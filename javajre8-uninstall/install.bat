
REM
REM   Uninstall-JavaJRE8
REM

REM Name
SET softname=Uninstall-JavaJRE8

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Silent uninstall %softname%
ScriptRunner.exe -appvscript WMIC product where "Name LIKE 'Java 8%%'" call uninstall /nointeractive -appvscriptrunnerparameters -wait -timeout=300
ScriptRunner.exe -appvscript WMIC product where "Name LIKE 'Java 7%%'" call uninstall /nointeractive -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
