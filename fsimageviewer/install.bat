
REM
REM   FastStoneImageViewer
REM

REM Name
SET softname=FastStoneImageViewer

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript FSViewerSetup-%softversion%.exe /S -appvscriptrunnerparameters -wait -timeout=300


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\FastStone*Image*Viewer.lnk"          DEL /F /Q "%PUBLIC%\Desktop\FastStone*Image*Viewer.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\FastStone*Image*Viewer.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\FastStone*Image*Viewer.lnk"


@ECHO [END] %date%-%time%
EXIT
