REM @ECHO OFF

REM
REM   AcrobatReader
REM

REM Name
SET softname=AcrobatReader

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

REM https://silentinstallhq.com/adobe-reader-silent-uninstall-strings-master-list/
ECHO Uninstall %softname% Silent
Msiexec /x {AC76BA86-7AD7-1033-7B44-AC0F074E4100} /qn

ECHO Silent Install %softname%
AcroRdrDCx64%softversion%_fr_FR.exe /sAll /rs /msi EULA_ACCEPT=YES DISABLEDESKTOPSHORTCUT=1 /L*V "%logdir%\%softname%-MSI.log"

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Adobe Reader X.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Adobe Reader X.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Adobe Reader X.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Adobe Reader X.lnk"
IF EXIST "%PUBLIC%\Desktop\Adobe*Acrobat.lnk"           DEL /F /Q "%PUBLIC%\Desktop\Adobe*Acrobat.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Adobe*Acrobat.lnk"  DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Adobe*Acrobat.lnk"


ECHO END %date%-%time%
EXIT
