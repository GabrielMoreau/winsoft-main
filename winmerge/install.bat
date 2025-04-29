
REM
REM   WinMerge
REM

REM Name
SET softname=WinMerge

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO BEGIN %date%-%time%


SET softversion=__VERSION__


@ECHO Silent install %softname%
ScriptRunner.exe -appvscript WinMerge-%softversion%-x64-Setup.exe /VERYSILENT /SP- /NORESTART /LOG="%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300 > "%logdir%\%softname%-SR.log" 2>&1
set SR_EXITCODE=%ERRORLEVEL%

FINDSTR /C:"Terminating process on timeout." "%logdir%\%softname%-SR.log" > NUL
IF %ERRORLEVEL% EQU 0 (
  @ECHO [ERROR] Timeout detected while running ScriptRunner
  @ECHO END %date%-%time%
  EXIT 44
)


@ECHO END %date%-%time%


IF %SR_EXITCODE% EQU 259 (
  @ECHO [INFO] 0 or 259 are good exit code for %softname% installer!
  EXIT 0
)
EXIT %SR_EXITCODE%
