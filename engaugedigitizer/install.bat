
REM
REM   EngaugeDigitizer
REM

REM Name
SET softname=EngaugeDigitizer

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
msiexec /i "digit-exe-windows10-64-bit-installer-%softversion%.msi" /qn /norestart /L*v "%logdir%\%softname%-MSI.log"

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Engauge Digitizer.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Engauge Digitizer.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Engauge Digitizer.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Engauge Digitizer.lnk"


ECHO END %date%-%time%
EXIT
