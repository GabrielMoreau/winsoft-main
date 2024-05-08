
REM
REM   Octave
REM

REM Name
SET softname=Octave

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
ScriptRunner.exe -appvscript octave-%softversion%-w64-installer.exe /AllUsers /S -appvscriptrunnerparameters -wait -timeout=900


IF EXIST "%AppData%\octave\" COPY /A /Y "octave-gui.ini" "%AppData%\octave\octave-gui.ini"


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\GNU Octave (CLI).lnk"          DEL /F /Q "%PUBLIC%\Desktop\GNU Octave (CLI).lnk"
IF EXIST "%PUBLIC%\Desktop\GNU Octave (GUI).lnk"          DEL /F /Q "%PUBLIC%\Desktop\GNU Octave (GUI).lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\GNU Octave (CLI).lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\GNU Octave (CLI).lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\GNU Octave (GUI).lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\GNU Octave (GUI).lnk"


ECHO END %date%-%time%
EXIT
