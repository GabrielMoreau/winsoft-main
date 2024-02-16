REM @ECHO OFF

REM
REM   PDFCreator
REM

REM Name
SET softname=PDFCreator

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__

REM IF EXIST "%ProgramFiles%\PDFCreator\unins000.exe" "%ProgramFiles%\PDFCreator\unins000.exe" /verysilent
REM ping 127.0.0.1 -n 6 > NUL

REM SET regkey=FALSE
REM IF "%softversion%"=="0.9.3" SET regkey={0001B4FD-9EA3-4D90-A79E-FD14BA3AB01D}
REM IF "%softversion%"=="0.9.7" SET regkey={0001B4FD-9EA3-4D90-A79E-FD14BA3AB01D}
REM PDF Creator ne semble pas changer de clef...
REM SET regkey={0001B4FD-9EA3-4D90-A79E-FD14BA3AB01D}


REM https://docs.pdfforge.org/pdfcreator/en/pdfcreator/installing-pdfcreator/setup-command-line-parameters/#verysilent
REM No Architect Component

ECHO Silent install %softname%
"PDFCreator-%softversion%-setup.exe" /VerySilent /NoRestart /NoIcons /COMPONENTS="none" /sp-


REM Program Menu
REM CD "%ALLUSERSPROFILE%\Menu*\Programmes"
REM MKDIR "Accessoires"
REM COPY /B /Y "%ALLUSERSPROFILE%\Bureau\PDFCreator.lnk" "Accessoires\PDFCreator - Manager.lnk"
REM DEL /F /Q "%ALLUSERSPROFILE%\Bureau\PDFCreator.lnk"


ECHO END %date%-%time%
EXIT
