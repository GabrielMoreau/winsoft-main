
REM
REM   OpenVPN
REM

REM Name
SET softname=OpenVPN

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
REM Only for version 2.6: ADDLOCAL=OpenVPN.GUI,OpenVPN,OpenVPN.GUI.OnLogon,Drivers.TAPWindows6,Drivers
ScriptRunner.exe -appvscript MsiExec.exe /i "openvpn-connect-%softversion%_signed.msi" /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\OpenVPN Connect.lnk"          DEL /F /Q "%PUBLIC%\Desktop\OpenVPN Connect.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\OpenVPN Connect.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\OpenVPN Connect.lnk"


@ECHO [END] %date%-%time%
EXIT
