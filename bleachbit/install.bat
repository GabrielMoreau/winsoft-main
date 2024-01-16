REM @ECHO OFF

REM
REM   BleachBit
REM

REM Name
SET softname=BleachBit

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


REM ECHO Silent uninstall previous version
REM IF EXIST "%ProgramFiles%\BleachBit\uninstall.exe"      "%ProgramFiles%\BleachBit\uninstall.exe" /allusers /S
REM IF EXIST "%ProgramFiles(x86)%\BleachBit\uninstall.exe" "%ProgramFiles(x86)%\BleachBit\uninstall.exe" /allusers /S


ECHO Silent install %softname%
BleachBit-%softversion%-setup.exe /allusers /S


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\BleachBit.lnk"          DEL /F /Q "%PUBLIC%\Desktop\BleachBit.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\BleachBit.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\BleachBit.lnk"


ECHO END %date%-%time%
EXIT
