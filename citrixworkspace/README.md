# CitrixWorkspace - Citrix remote workspace client

Citrix Workspace is an information retrieval service where users can
access programs and files from a variety of sources through a central
application or a Web browser.

* Website : https://www.citrix.com/
* Wikipedia : https://en.wikipedia.org/wiki/Citrix_Workspace

* Download : https://www.citrix.com/fr-fr/downloads/workspace-app/windows/workspace-app-for-windows-latest.html
* Silent install : https://silentinstallhq.com/citrix-workspace-app-silent-install-how-to-guide/
                   https://docs.citrix.com/en-us/citrix-workspace-app-for-windows/install.html


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Citrix Authentication Manager | Citrix Systems, Inc. | 25.3.0.21  | `{45316F51-364F-42E8-81F4-D9BBA2FAA187}` | `MsiExec.exe /X{45316F51-364F-42E8-81F4-D9BBA2FAA187}` |
 | HKLM | Citrix Desktop Lock           | Citrix Systems, Inc. | 25.3.0.78  | `{C136A44B-539A-4BE5-9749-3ADDC3A97F68}` | `MsiExec.exe /I{C136A44B-539A-4BE5-9749-3ADDC3A97F68}` |
 | HKLM | Citrix Web Helper             | Citrix Systems, Inc. | 25.3.0.82  | `{4AB5227D-4B35-4984-B1C0-7481C52EF4FA}` | `MsiExec.exe /X{4AB5227D-4B35-4984-B1C0-7481C52EF4FA}` |
 | HKLM | Citrix Workspace (DV)         | Citrix Systems, Inc. | 25.3.0.185 | `{221513D1-79E6-4ACE-8B78-D2307B2B4710}` | `MsiExec.exe /X{221513D1-79E6-4ACE-8B78-D2307B2B4710}` |
 | HKLM | Citrix Workspace (USB)        | Citrix Systems, Inc. | 25.3.0.185 | `{9B691F3E-CAA0-44BB-9882-5B072414D427}` | `MsiExec.exe /I{9B691F3E-CAA0-44BB-9882-5B072414D427}` |
 | HKLM | Citrix Workspace 2503         | Citrix Systems, Inc. | 25.3.0.189 | `CitrixOnlinePluginPackWeb`              | `"C:\Program Files (x86)\Citrix\Citrix Workspace 2503\bootstrapperhelper.exe" /uninstall /cleanup` |
 | HKLM | Citrix Workspace Inside       | Citrix Systems, Inc. | 25.3.0.71  | `{F76084BC-5D1D-4594-BDDD-D1439E9370CB}` | `MsiExec.exe /I{F76084BC-5D1D-4594-BDDD-D1439E9370CB}` |
 | HKLM | Citrix Workspace(SSON)        | Citrix Systems, Inc. | 25.3.0.75  | `{2B28504C-BE92-4C9A-9DE3-5BDDC566D482}` | `MsiExec.exe /I{2B28504C-BE92-4C9A-9DE3-5BDDC566D482}` |
