REM @ECHO OFF

REM
REM   Chrome
REM

REM Name
SET softname=Chrome

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL

SET softversion=91.5.1
SET softpatch=1

REM Silent install
msiexec /i "googlechromestandaloneenterprise64-%softversion%.msi" /qn /L*V "%logdir%\%softname%-MSI.txt"


REM Disable auto update
sc stop gupdate
sc config gupdate start= disabled
regedit.exe /S "chrome-manual-updates.reg"

REM Copy preferences
IF EXIST "C:\Program Files (x86)\Google\Chrome\Application\" (
	COPY /B /Y "master_preferences.json" "C:\Program Files (x86)\Google\Chrome\Application\master_preferences"
	)
IF EXIST "C:\Program Files\Google\Chrome\Application\" (
	COPY /B /Y "master_preferences.json" "C:\Program Files\Google\Chrome\Application\master_preferences"
	)

EXIT
