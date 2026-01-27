
REM
REM   Ultracopier
REM

REM Name
SET softname=Ultracopier

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__


@ECHO [INFO] Remove old version (not clean but work's with /S flag)
IF EXIST "%ProgramFiles%\Ultracopier" (
  RMDIR /S /Q "%ProgramFiles%\Ultracopier"
)
IF EXIST "%ProgramFiles(x86)%\Ultracopier" (
  RMDIR /S /Q "%ProgramFiles(x86)%\Ultracopier"
)
REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Ultracopier"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Ultracopier" /F
)
REG QUERY "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Ultracopier"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Ultracopier" /F
)


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript ultracopier-windows-x86_64-%softversion%-setup.exe /S -appvscriptrunnerparameters -wait -timeout=300


@ECHO [END] %date%-%time%
EXIT
