# MS Teams - Microsoft Videoconferencing and communication platform

Microsoft Teams is a proprietary business communication platform, as
part of the Microsoft 365 family of products. Teams offering workspace
chat and videoconferencing, file storage, and application integration.

* Website : https://www.microsoft.com/fr-fr/microsoft-teams/
* Deployment : https://learn.microsoft.com/en-us/microsoftteams/msi-deployment

* Configure by GPO : https://www.it-connect.fr/deployer-et-configurer-teams-par-gpo/
* Deploy by Office : https://learn.microsoft.com/en-us/deployoffice/teams-install
* PowerShell script for reset the autostart setting : https://learn.microsoft.com/en-us/microsoftteams/scripts/powershell-script-teams-reset-autostart
* Silent install : https://silentinstallhq.com/microsoft-teams-silent-uninstall-powershell/

The installation creates a directory in `C:\Program Files (x86)\Teams Installer` with an installer and a config file in JSON format.
Then for each new session, the Teams program is in the user's home in `C:\Users\login\ApplData\Local\Microsoft\Teams`.


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Teams Machine-Wide Installer | Microsoft Corporation | 1.7.0.33761 | `{731F6BAA-A986-45A4-8936-7C3AAAAA760B}` | `MsiExec.exe /I{731F6BAA-A986-45A4-8936-7C3AAAAA760B}` |
