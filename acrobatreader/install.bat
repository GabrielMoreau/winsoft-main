
REM
REM   AcrobatReader
REM

REM Name
SET softname=AcrobatReader

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__

REM https://silentinstallhq.com/adobe-reader-silent-uninstall-strings-master-list/
ECHO Uninstall %softname% Silent
ScriptRunner.exe -appvscript MsiExec.exe /x {AC76BA86-7AD7-1033-7B44-AC0F074E4100} /qn -appvscriptrunnerparameters -wait -timeout=300


ECHO Silent Install %softname%
ScriptRunner.exe -appvscript AcroRdrDCx64%softversion%_fr_FR.exe /sAll /rs /msi EULA_ACCEPT=YES DISABLEDESKTOPSHORTCUT=1 /L*V "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Adobe*Reader*.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Adobe*Reader*.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Adobe*Reader*.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Adobe*Reader*.lnk"
IF EXIST "%PUBLIC%\Desktop\Adobe*Acrobat.lnk"           DEL /F /Q "%PUBLIC%\Desktop\Adobe*Acrobat.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Adobe*Acrobat.lnk"  DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Adobe*Acrobat.lnk"


ECHO END %date%-%time%
EXIT
