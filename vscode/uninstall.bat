
REM
REM   Uninstall-VSCode
REM

REM Name
SET softname=Uninstall-VSCode

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Silent uninstall %softname%
IF EXIST "%ProgramFiles%\Microsoft VS Code\unins000.exe" ScriptRunner.exe -appvscript "%ProgramFiles%\Microsoft VS Code\unins000.exe" /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300
IF EXIST "%ProgramFiles(x86)%\Microsoft VS Code\unins000.exe" ScriptRunner.exe -appvscript "%ProgramFiles(x86)%\Microsoft VS Code\unins000.exe" /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
