REM @ECHO OFF

REM
REM   Filezilla
REM

REM Name
SET softname=FileZilla-Client

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

REM Version parameter (auto update by Makefile)
SET softversion=__VERSION__
SET softexe=FileZilla_%softversion%_win64-setup.exe

ECHO Uninstall previous version if exist
IF EXIST "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" (
  "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" /S
)
IF EXIST "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" (
  "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" /S
)
IF EXIST "%ProgramFiles(x86)%\FileZilla FTP Client\uninstall.exe" (
  "%ProgramFiles(x86)%\FileZilla FTP Client\uninstall.exe" /S
)
IF EXIST "%ProgramFiles(x86)%\FileZilla FTP Client\uninstall.exe" (
  "%ProgramFiles(x86)%\FileZilla FTP Client\uninstall.exe" /S
)

ECHO Silent install
"%softexe%" /user=all /S

ECHO Disable welcome and check update
IF EXIST "%ProgramFiles%\FileZilla FTP Client" (
  COPY /A /Y "fzdefaults.xml" "%ProgramFiles%\FileZilla FTP Client\fzdefaults.xml"
)
IF EXIST "%ProgramFiles(x86)%\FileZilla FTP Client" (
  COPY /A /Y "fzdefaults.xml" "%ProgramFiles(x86)%\FileZilla FTP Client\fzdefaults.xml"
)


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"

ECHO Execute post-install script
%pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO END %date%-%time%
EXIT
