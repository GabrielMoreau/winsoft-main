# OnlyOffice - Desktop offline office suite version

OnlyOffice is a free and open-source software office suite and ecosystem of collaborative applications.
It consists of online editors for text documents, spreadsheets, presentations, forms and PDFs.
OnlyOffice Desktop is an offline version of OnlyOffice editing suite.
The desktop application supports collaborative editing features when connected to Nextcloud, Seafile, etc.
The desktop editors are cross-platform.

* Website : https://www.onlyoffice.com/
* Source : https://github.com/ONLYOFFICE/DesktopEditors
* Wikipedia : https://en.wikipedia.org/wiki/OnlyOffice

* Download : https://github.com/ONLYOFFICE/DesktopEditors/releases,
	https://www.onlyoffice.com/download-desktop.aspx
* Silent install : https://silentinstallhq.com/onlyoffice-desktop-editors-install-and-uninstall-powershell/


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | ONLYOFFICE | Ascensio System SIA | 8.3.1.25 | `{BCD0F16A-6306-A9BA-5740-C04AE87E9AB3}` | `MsiExec.exe /X{BCD0F16A-6306-A9BA-5740-C04AE87E9AB3}` |
 | HKLM | ONLYOFFICE 8.3.1 (x64) | Ascensio System SIA | 8.3.1.25 | `ONLYOFFICE Desktop Editors` | `msiexec.exe /x {BCD0F16A-6306-A9BA-5740-C04AE87E9AB3} AI_UNINSTALLER_CTP=1` |
