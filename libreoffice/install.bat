
REM
REM   LibreOffice
REM

REM Name
SET softname=LibreOffice

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__
SET process=soffice.bin
SET MAX_RETRY=1


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


:REINSTALL
ECHO Silent Install %softname%
REM https://wiki.documentfoundation.org/Deployment_and_Migration
IF EXIST "LibreOffice_%softversion%_Win_x86-64.msi" (
  ScriptRunner.exe -appvscript MsiExec.exe /i "LibreOffice_%softversion%_Win_x86-64.msi" /qn /norestart /l "%logdir%\%softname%-MSI.log" CREATEDESKTOPLINK=0 RebootYesNo=No ISCHECKFORPRODUCTUPDATES=0 REGISTER_NO_MSO_TYPES=1 REMOVE=gm_o_Onlineupdate SELECT_WORD=0 SELECT_EXCEL=0 SELECT_POWERPOINT=0 USERNAME="LEGI" ADDLOCAL=ALL -appvscriptrunnerparameters -wait -timeout=450
) ELSE (
    ECHO Error: installer is not in the archive!
)

ECHO Check if installed
IF EXIST "%ProgramFiles%\LibreOffice\program\soffice.exe" (
  GOTO POSTINSTALL
) ELSE (
  IF "%MAX_RETRY%"=="0" (
    ECHO Error: MAX_RETRY installation done and no %softname%
    SET RETURNCODE=140
    GOTO END
  ) ELSE (
    ECHO Warning: try installation again
    SET /A MAX_RETRY-=1
    GOTO REINSTALL
  )
)


:POSTINSTALL
ECHO Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:HELP
ECHO Silent help install
ScriptRunner.exe -appvscript MsiExec.exe /i "LibreOffice_%softversion%_Win_x86-64_helppack_fr.msi" /qn /norestart /l "%logdir%\%softname%-HELP.log" -appvscriptrunnerparameters -wait -timeout=300
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:END
ECHO END %date%-%time%
EXIT %RETURNCODE%
