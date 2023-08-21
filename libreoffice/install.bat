REM @ECHO OFF

REM
REM   LibreOffice
REM

REM Name
SET softname=LibreOffice

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

SET process=soffice.bin

REM https://wiki.documentfoundation.org/Deployment_and_Migration

ECHO Silent install %softname%
msiexec /qn /i "LibreOffice_%softversion%_Win_x86-64.msi" /norestart /l "%logdir%\%softname%-MSI.log" CREATEDESKTOPLINK=0 RebootYesNo=No ISCHECKFORPRODUCTUPDATES=0 REGISTER_NO_MSO_TYPES=1 REMOVE=gm_o_Onlineupdate SELECT_WORD=0 SELECT_EXCEL=0 SELECT_POWERPOINT=0 USERNAME="LEGI" ADDLOCAL=ALL

ECHO Silent help install
msiexec /qn /i "LibreOffice_%softversion%_Win_x86-64_helppack_fr.msi" /norestart /l "%logdir%\%softname%-HELP.log"


ECHO END %date%-%time%
EXIT
