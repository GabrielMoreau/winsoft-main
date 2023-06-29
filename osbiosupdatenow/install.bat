REM @ECHO OFF

REM
REM   OSBIOSUpdateNow
REM

REM Name
SET softname=OSBIOSUpdateNow

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=91.5.1
SET softpatch=1


ECHO Windows update
REM UsoClient ScanInstallWait
wuauclt /detectnow /updatenow


ECHO Wait 30 s
ping 127.0.0.1 -n 30 > NUL


IF EXIST "%ProgramFiles%\Dell\CommandUpdate\dcu-cli.exe"      GOTO DELL64
IF EXIST "%ProgramFiles(x86)%\Dell\CommandUpdate\dcu-cli.exe" GOTO DELL86
IF EXIST "%ProgramFiles%\HP\HPIA\HPImageAssistant.exe         GOTO HP64
GOTO END


:DELL64
ECHO DELL BIOS update
"%ProgramFiles%\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates -silent -autoSuspendBitlocker=enable -reboot=disable -outputLog="%SystemDrive%\Temp\Dell-BIOS-DCU.log"
GOTO END

:DELL86
ECHO DELL BIOS update
"%ProgramFiles(x86)%\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates -silent -autoSuspendBitlocker=enable -reboot=disable -outputLog="%SystemDrive%\Temp\Dell-BIOS-DCU.log"
GOTO END

:HP64
ECHO HP BIOS update
REM See https://ftp.hp.com/pub/caps-softpaq/cmit/imagepal/userguide/936944-005.pdf
"%ProgramFiles%\HP\HPIA\HPImageAssistant.exe /Operation:Analyze /Action:Install /Category:BIOS /AutoCleanup /SoftPaqDownloadFolder:"%SystemDrive%\Temp\HPIA\download" /Debug /Silent /ReportFilePath:"%SystemDrive%\Temp\HPIA\HPIA-Report.html"
GOTO END


:END
ECHO END %date%-%time%
EXIT
