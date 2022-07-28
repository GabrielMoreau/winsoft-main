REM @ECHO OFF

REM
REM   WinSCP
REM

REM Name
SET softname=WinSCP

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=2.6.11
SET softpatch=1


REM Silent install
WinSCP-%softversion%-Setup.exe /VERYSILENT /NORESTART /ALLUSERS /MERGETASKS=!desktopicon /LOG="%logdir%\%softname%-MSI.log"

REM Comment beacuse of HKCU reg
REM Disable WinSCP Check For Updates
REM REG ADD "HKCU\SOFTWARE\Martin Prikryl\WinSCP 2\Configuration\Interface\Updates" /v "Period" /t REG_DWORD /d "00000000" /f
REM REG ADD "HKCU\SOFTWARE\Martin Prikryl\WinSCP 2\Configuration\Interface\Updates" /v "ShowOnStartup" /t REG_DWORD /d "00000000" /f
REM Disable WinSCP Check For Beta Versions
REM REG ADD "HKCU\SOFTWARE\Martin Prikryl\WinSCP 2\Configuration\Interface\Updates" /v "BetaVersions" /t REG_DWORD /d "00000001" /f
REM Disable WinSCP Collection of Anonymous Usage Statistics
REM REG ADD "HKCU\SOFTWARE\Martin Prikryl\WinSCP 2\Configuration\Interface" /v "CollectUsage" /t REG_DWORD /d "00000000" /f


ECHO END %date%-%time%
EXIT
