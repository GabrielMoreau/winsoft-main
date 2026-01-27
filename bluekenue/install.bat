
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

@ECHO [BEGIN] %date%-%time%

REM https://nrc.canada.ca/fr/recherche-developpement/produits-services/logiciels-applications/blue-kenuetm-logiciel-modelisateurs-hydrauliques

SET softversion=__VERSION__


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript MsiExec.exe /i "BlueKenue64Installer%softversion%.msi" /quiet /qn /norestart /log "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\BlueKenue 64.lnk"          DEL /F /Q "%PUBLIC%\Desktop\BlueKenue 64.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\BlueKenue 64.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\BlueKenue 64.lnk"


@ECHO [END] %date%-%time%
EXIT
