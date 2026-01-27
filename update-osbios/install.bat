
REM
REM   Update-OSBIOS
REM

REM Name
SET softname=Update-OSBIOS

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__


@ECHO [INFO] Choose OS
VER | FIND /I "10.0.19" > NUL
IF %ERRORLEVEL%==0 GOTO WIN10

VER | FIND /I "10.0.22" > NUL
IF %ERRORLEVEL%==0 GOTO WIN11

:WIN10
@ECHO [INFO] Windows 10 update
UsoClient.exe ScanInstallWait
REM wuauclt /detectnow /updatenow
GOTO NEXT

:WIN11
@ECHO [INFO] Windows 11 update
Windows11InstallationAssistant-__VERSION11__.exe /QuietInstall /SkipEULA /NoRestartUI
GOTO NEXT


:NEXT
@ECHO [INFO] Wait 30 s
ping 127.0.0.1 -n 30 > NUL


@ECHO [INFO] Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

@ECHO [INFO] Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

@ECHO [INFO] Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0

@ECHO [INFO] Execute post-install script
%pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


IF EXIST "%ProgramFiles%\Dell\CommandUpdate\dcu-cli.exe"      GOTO DELL64
IF EXIST "%ProgramFiles(x86)%\Dell\CommandUpdate\dcu-cli.exe" GOTO DELL86
IF EXIST "%ProgramFiles%\HP\HPIA\HPImageAssistant.exe         GOTO HP64
GOTO END


:DELL64
@ECHO [INFO] DELL BIOS update
"%ProgramFiles%\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates -silent -autoSuspendBitlocker=enable -reboot=disable -outputLog="%SystemDrive%\Temp\Dell-BIOS-DCU.log"
GOTO END

:DELL86
@ECHO [INFO] DELL BIOS update
"%ProgramFiles(x86)%\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates -silent -autoSuspendBitlocker=enable -reboot=disable -outputLog="%SystemDrive%\Temp\Dell-BIOS-DCU.log"
GOTO END

:HP64
@ECHO [INFO] HP BIOS update
REM See https://ftp.hp.com/pub/caps-softpaq/cmit/imagepal/userguide/936944-005.pdf
"%ProgramFiles%\HP\HPIA\HPImageAssistant.exe /Operation:Analyze /Action:Install /Category:BIOS /AutoCleanup /SoftPaqDownloadFolder:"%SystemDrive%\Temp\HPIA\download" /Debug /Silent /ReportFilePath:"%SystemDrive%\Temp\HPIA\HPIA-Report.html"
GOTO END


:END
@ECHO [END] %date%-%time%
EXIT
