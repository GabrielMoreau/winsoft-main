
REM
REM   ProtonMailBridge
REM

REM Name
SET softname=ProtonMailBridge

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
ScriptRunner.exe -appvscript Bridge-Installer-%softversion%.exe /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Proton Mail Bridge.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Proton Mail Bridge.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Proton Mail Bridge.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Proton Mail Bridge.lnk"


@ECHO [END] %date%-%time%
EXIT
