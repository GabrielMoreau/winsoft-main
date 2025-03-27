# UltiMaker Cura - 3D printing software

UltiMaker Cura is free and open-source, easy-to-use 3D printing software trusted by millions of users.
Fine-tune your 3D model with 400+ settings for the best slicing and printing results.

* Website : https://ultimaker.com
* Wikipedia : https://en.wikipedia.org/wiki/Cura_(software)

* Download : https://github.com/Ultimaker/Cura/releases/latest
* Silent install : https://www.manageengine.com/eu/products/desktop-central/software-installation/silent_install_UltiMaker-Cura-(5.3.1).html,
	https://silent-install.net/software/ultimaker/cura/4.5.0


## Installer

```bat
REM Silent Install (exe or msi)
Ultimaker_Cura-4.5.0-win64.exe /S
MsiExec.exe /i "UltiMaker-Cura-win64.msi" /qn /norestart

REM Silent Uninstall (exe or msi)
"%ProgramW6432%\Ultimaker Cura 4.5\Uninstall.exe" /S
MsiExec.exe /x {GUID} /qn /norestart
```


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | UltiMaker Cura | UltiMaker | 5.4.0 | `{7C3B43E0-0A17-4029-9146-19F3E0566B4C}` | `MsiExec.exe /I{7C3B43E0-0A17-4029-9146-19F3E0566B4C}` |
 | HKLM | UltiMaker Cura | UltiMaker | 5.5.0 | `{3AC2EF24-9745-4516-BF41-85F9223E03F7}` | `MsiExec.exe /I{3AC2EF24-9745-4516-BF41-85F9223E03F7}` |
 | HKLM | UltiMaker Cura | UltiMaker | 5.9.1 | `{886DAE2D-EA56-4B5D-8835-FBC619403268}` | `MsiExec.exe /I{886DAE2D-EA56-4B5D-8835-FBC619403268}` |
 | HKLM | UltiMaker Cura | UltiMaker | 5.10.0 | `{19058516-3EE9-4BA2-80B8-74FD88D1461F}` | `MsiExec.exe /I{19058516-3EE9-4BA2-80B8-74FD88D1461F}` |
