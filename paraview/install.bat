REM @ECHO OFF

REM
REM   ParaView
REM

REM Name
SET softname=ParaView

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=5.10.2
SET softpatch=1
SET softexe=ParaView-5.10.2.msi


REM Silent install
msiexec /i "%softexe%" ALLUSERS=1 /qn /L*v "%logdir%\%softname%-MSI.log" 


ECHO END %date%-%time%
EXIT
