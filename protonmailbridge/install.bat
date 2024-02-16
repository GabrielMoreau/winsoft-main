
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

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__


ECHO Silent install %softname%
Bridge-Installer-%softversion%.exe /qn /norestart /L*v "%logdir%\%softname%-MSI.log"


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Proton Mail Bridge.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Proton Mail Bridge.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Proton Mail Bridge.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Proton Mail Bridge.lnk"


ECHO END %date%-%time%
EXIT
