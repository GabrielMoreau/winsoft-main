
REM
REM   BlueKenue
REM

REM Name
SET softname=BlueKenue

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

REM https://nrc.canada.ca/fr/recherche-developpement/produits-services/logiciels-applications/blue-kenuetm-logiciel-modelisateurs-hydrauliques

SET softversion=__VERSION__


ECHO Silent install %softname%
ScriptRunner.exe -appvscript MsiExec.exe /i "BlueKenue64Installer%softversion%.msi" /quiet /qn /norestart /log "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
