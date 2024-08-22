
REM
REM   K-Lite-CodecPackStandard
REM

REM Name
SET softname=K-Lite-CodecPackStandard

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
ScriptRunner.exe -appvscript K-Lite_Codec_Pack_%softversion%_Standard.exe /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
