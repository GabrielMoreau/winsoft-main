
REM
REM   Notepad++
REM

REM Name
SET softname=Notepad++

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

ECHO Version parameter (auto update by Makefile)
SET softversion=__VERSION__
SET softexe=npp.%softversion%.Installer.x64.exe
SET regkey=Notepad++


ECHO Kill running process
TASKKILL /IM notepad++.exe /F


ECHO Uninstall previous version
IF EXIST "%ProgramFiles%\Notepad++\uninstall.exe" (
  ScriptRunner.exe -appvscript "%ProgramFiles%\Notepad++\uninstall.exe" /S -appvscriptrunnerparameters -wait -timeout=300
)

SET /A LOOPCOUNT=0
:WAIT
SET /A LOOPCOUNT+=1
IF %LOOPCOUNT% GEQ 31 (
  ECHO Error: Too many loop before uninstall finish - Continue and cross our fingers!
  GOTO NEXT
)
ECHO Loop counter: %LOOPCOUNT%
ping 127.0.0.1 -n 6 > NUL
REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 GOTO WAIT
REG QUERY "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 GOTO WAIT
ping 127.0.0.1 -n 3 > NUL


:NEXT

ECHO Silent install %softname%
ScriptRunner.exe -appvscript "%softexe%" /S -appvscriptrunnerparameters -wait -timeout=300


ECHO Disable auto update
IF EXIST "%ProgramFiles%\Notepad++\updater_disable" (
  RMDIR /S /Q "%ProgramFiles%\Notepad++\updater_disable"
)
IF EXIST "%ProgramFiles%\Notepad++\updater" (
  RENAME "%ProgramFiles%\Notepad++\updater" "updater_disable"
)


ECHO END %date%-%time%
EXIT
