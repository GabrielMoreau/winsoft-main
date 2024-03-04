
REM
REM   PDFCreator
REM

REM Name
SET softname=PDFCreator

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__


REM https://docs.pdfforge.org/pdfcreator/en/pdfcreator/installing-pdfcreator/setup-command-line-parameters/#verysilent
REM No Architect Component


ECHO Silent install %softname%
ScriptRunner.exe -appvscript "PDFCreator-%softversion%-setup.exe" /VerySilent /NoRestart /NoIcons /COMPONENTS="none" /sp- -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
