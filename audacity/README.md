# Audacity - Digital Audio Editor

Audacity is a free and open-source digital audio editor and recording
application software.

* Website : https://wiki.audacityteam.org/wiki/Audacity_Wiki_Home_Page
* Wikipedia : https://en.wikipedia.org/wiki/Audacity_(audio_editor)

* Download : https://www.audacityteam.org/download/windows/
* Silent install : https://silent-install.net/software/audacity_team/audacity/2.3.0

```bat
audacity-win-2.4.0.exe /TASKS="!desktopicon,!resetprefs" /VERYSILENT /NORESTART /LOG="%TEMP%\Audacity 2.4.0.log"
"%ProgramFiles%\Audacity\unins000.exe" /VERYSILENT /NORESTART
```


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Audacity 3.4.2 | Audacity Team | 3.4.2           | `Audacity_is1`                           | `"C:\Program Files\Audacity\unins000.exe"` |
 | HKLM | Audacity 3.7.0 | Audacity Team | 3.7.0           | `Audacity_is1`                           | `"C:\Program Files\Audacity\unins000.exe"` |
 | HKLM | Audacity 3.7.8 | Audacity Team | 3.7.8           | `Audacity_is1`                           | `"C:\Program Files\Audacity\unins000.exe"` |
 | HKLM | Audacity 4.0   | Audacity      | 4.0.2.263060742 | `{6CECECEA-CC25-46AF-AACE-DD7EA6FB83D3}` | `MsiExec.exe /X{6CECECEA-CC25-46AF-AACE-DD7EA6FB83D3}` |
