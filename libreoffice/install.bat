
REM
REM   LibreOffice
REM

REM Name
SET softname=LibreOffice

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__

SET process=soffice.bin


ECHO Silent install %softname%
REM https://wiki.documentfoundation.org/Deployment_and_Migration
ScriptRunner.exe -appvscript MsiExec.exe /i "LibreOffice_%softversion%_Win_x86-64.msi" /qn /norestart /l "%logdir%\%softname%-MSI.log" CREATEDESKTOPLINK=0 RebootYesNo=No ISCHECKFORPRODUCTUPDATES=0 REGISTER_NO_MSO_TYPES=1 REMOVE=gm_o_Onlineupdate SELECT_WORD=0 SELECT_EXCEL=0 SELECT_POWERPOINT=0 USERNAME="LEGI" ADDLOCAL=ALL -appvscriptrunnerparameters -wait -timeout=300

ECHO Silent help install
ScriptRunner.exe -appvscript MsiExec.exe /i "LibreOffice_%softversion%_Win_x86-64_helppack_fr.msi" /qn /norestart /l "%logdir%\%softname%-HELP.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
