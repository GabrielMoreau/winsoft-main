REM @ECHO OFF

REM
REM   PuTTY
REM

REM Name
SET softname=PuTTY

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO Silent install %softname%
msiexec /i putty-64bit-%softversion%-installer.msi /qn /norestart /L*v "%logdir%\%softname%-MSI.log"

REM 0.78 "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{4EEF2644-700F-46F8-9655-915145248986}"
REM 0.77 "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E078C644-A120-4668-AD62-02E9FD530190}"

REM Clean register
REM Putty version 0.78
REM REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{4EEF2644-700F-46F8-9655-915145248986}"
REM IF %ERRORLEVEL% EQU 0 (
REM   REM Putty version 0.77
REM   REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E078C644-A120-4668-AD62-02E9FD530190}"
REM   IF %ERRORLEVEL% EQU 0 (
REM     REM Delete old key
REM     REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{E078C644-A120-4668-AD62-02E9FD530190}" /VA /F
REM   )
REM )


ECHO Execute post-install script
%pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1


ECHO END %date%-%time%

REM IF %ERRORLEVEL% EQU 1603 (
REM   REM 0 or 1603 are good exit code for Putty MSI installer!
REM   EXIT 0
REM )
EXIT
