REM @ECHO OFF

REM
REM   TortoiseSVN
REM

REM Name
SET softname=TortoiseSVN

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


REM Silent install
ScriptRunner.exe -appvscript MsiExec.exe /i "TortoiseSVN-%softversion%-x64.msi" /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
