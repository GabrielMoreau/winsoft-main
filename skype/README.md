# Skype - VoIP and Videoconferencing Client

Skype is a proprietary telecommunications application, best known for
VoIP-based videotelephony, videoconferencing and voice calls.
It also has instant messaging, file transfer, debit-based calls to
landline and mobile telephones (over traditional telephone networks),
and other features.

* Website : https://www.skype.com/
* Wikipedia : https://en.wikipedia.org/wiki/Skype

* Download : https://www.skype.com/fr/get-skype/
* Silent install : https://silentinstallhq.com/skype-for-desktop-silent-install-how-to-guide/


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Skype version 8.118 | Skype Technologies S.A. | 8.118 | `Skype_is1` | `"C:\Program Files (x86)\Microsoft\Skype for Desktop\unins000.exe"` |


## Download

The final file does not have the same name as the initial file.
With `wget`, it is possible to get the final file directly.

```bash
wget --content-disposition https://go.skype.com/windows.desktop.download
```

It is possible to have just the header and 0 or 1 redirect in order to
have the URL where the version number can be found.

```bash
wget --max-redirect=1 https://go.skype.com/windows.desktop.download
```

All you need to do is make the appropriate `curl` request.

Remember: `curl` is preferable to `wget` so that you can run the
commands under Linux or MacOSX.
