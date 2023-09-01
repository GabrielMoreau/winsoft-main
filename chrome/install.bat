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
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET softpatch=__PATCH__

ECHO Silent install %softname%
msiexec /i "googlechromestandaloneenterprise64-%softversion%.msi" /qn /L*V "%logdir%\%softname%-MSI.log"


ECHO Disable auto update
sc stop gupdate
sc config gupdate start= disabled
regedit.exe /S "chrome-parameters.reg"

ECHO Copy preferences
IF EXIST "C:\Program Files (x86)\Google\Chrome\Application\" (
	COPY /B /Y "master_preferences.json" "C:\Program Files (x86)\Google\Chrome\Application\master_preferences"
	)
IF EXIST "C:\Program Files\Google\Chrome\Application\" (
	COPY /B /Y "master_preferences.json" "C:\Program Files\Google\Chrome\Application\master_preferences"
	)

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Google*Chrome.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Google*Chrome.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Google*Chrome.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Google*Chrome.lnk"


ECHO END %date%-%time%
EXIT
