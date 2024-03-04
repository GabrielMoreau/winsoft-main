
REM
REM   VeraCrypt
REM

REM Name
SET softname=VeraCrypt

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Silent install %softname%
ScriptRunner.exe -appvscript MsiExec.exe /i VeraCrypt-Setup-x64-%softversion%.msi ACCEPTLICENSE=YES INSTALLDESKTOPSHORTCUT="" /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%

IF %ERRORLEVEL% EQU 1603 (
  ECHO 0 or 1603 are good exit code for %softname% installer!
  EXIT 0
)
EXIT
