REM @ECHO OFF

REM
REM   HPSupportAssist
REM

REM Name
SET softname=HPSupportAssist

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Disabled automatic install, notifytray and notifypopup
Reg.exe ADD "HKLM\SOFTWARE\WOW6432Node\Hewlett-Packard\HPActiveSupport\HPSF" /v NotifyTray /t REG_SZ /d 0 /f
Reg.exe ADD "HKLM\SOFTWARE\WOW6432Node\Hewlett-Packard\HPActiveSupport\HPSF" /v NotifyPopup /t REG_SZ /d 0 /f
Reg.exe ADD "HKLM\SOFTWARE\WOW6432Node\Hewlett-Packard\HPActiveSupport\HPHC" /v Install /t REG_SZ /d 0 /f

ECHO Silent install %softname%
REM Setup.exe /s /v /q
InstallHPSA.exe /S /v/qn

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\HP*Support*Assistant.lnk"          DEL /F /Q "%PUBLIC%\Desktop\HP*Support*Assistant.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\HP*Support*Assistant.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\HP*Support*Assistant.lnk"


ECHO END %date%-%time%
EXIT
