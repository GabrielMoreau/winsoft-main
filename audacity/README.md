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
 | HKLM | Audacity 3.4.2 | Audacity Team | 3.4.2 | `Audacity_is1` | `"C:\Program Files\Audacity\unins000.exe"` |
