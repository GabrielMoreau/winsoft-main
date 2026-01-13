
REM
REM   Zotero
REM

REM Name
SET softname=Zotero

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
ScriptRunner.exe -appvscript Zotero-%softversion%_x64_setup.exe /S -appvscriptrunnerparameters -wait -timeout=300


:POSTINSTALL
ECHO Execute post-install script
%pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
SET RETURNCODE=%ERRORLEVEL%


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\%softname%.lnk"          DEL /F /Q "%PUBLIC%\Desktop\%softname%.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\%softname%.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\%softname%.lnk"


:END
ECHO END %date%-%time%
EXIT %RETURNCODE%
