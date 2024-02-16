REM @ECHO OFF

REM
REM   PDFsam Basic
REM

REM Name
SET softname=PDFsamBasic

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
msiexec /i "pdfsam-%softversion%.msi" /qn /norestart CHECK_FOR_UPDATES=false CHECK_FOR_NEWS=false PLAY_SOUNDS=false DONATE_NOTIFICATION=false SKIPTHANKSPAGE=Yes PREMIUM_MODULES=false /L*v "%logdir%\%softname%-MSI.log"


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\PDFsam*Basic.lnk"          DEL /F /Q "%PUBLIC%\Desktop\PDFsam*Basic.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\PDFsam*Basic.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\PDFsam*Basic.lnk"


ECHO END %date%-%time%
EXIT
