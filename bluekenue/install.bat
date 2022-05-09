REM @ECHO OFF
REM Hide the Window

REM "cmdow.exe" @ /hid

REM
REM   BlueKenue
REM

REM Name
SET softname=BlueKenue

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL

REM https://nrc.canada.ca/fr/recherche-developpement/produits-services/logiciels-applications/blue-kenuetm-logiciel-modelisateurs-hydrauliques

SET softversion=3.3.4
SET softpatch=1


REM Silent install
msiexec /i "BlueKenue64Installer%softversion%.msi" /quiet /qn /norestart /log c:\temp\bluekenuemsi.log


EXIT
