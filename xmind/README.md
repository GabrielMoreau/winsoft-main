# XMind - Mind mapping and collaboration application

Xmind is a mind mapping and collaboration application that incorporates artificial intelligence features.
Its primary functions are to facilitate brainstorming, organize information visually, and support project management and team sharing.

* Website : https://xmind.com/
* Wikipedia https://en.wikipedia.org/wiki/XMind
* Download : https://xmind.com/thank-you-for-downloading?download=win64

* Release Notes : https://xmind.com/desktop/release-notes/
* Silent install : https://www.manageengine.com/products/desktop-central/software-installation/silent_install_Xmind-(24.04.10311)-User_specific.html,
  https://community.chocolatey.org/packages/xmind-2020

Install location with the SYSTEM account `C:\WINDOWS\system32\config\systemprofile\AppData\Local\Programs\Xmind` !

The installer does not work well with the SYSTEM user (files are automatically deleted at the end of installation).
The solution is to extract the files from the installer and copy them to `%ProgramFiles%\Xmind`.


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKU  | Xmind 26.1.3145 | XMIND LTD. | 26.1.3145 | `fbd30ee5-8150-549e-9aed-fd9d444364fb` | `"C:\WINDOWS\system32\config\systemprofile\AppData\Local\Programs\Xmind\Uninstall Xmind.exe" /currentuser` |
 | HKCU | Xmind 26.1.3145 | XMIND LTD. | 26.1.3145 | `fbd30ee5-8150-549e-9aed-fd9d444364fb` | `"C:\Users\XXXXX\AppData\Local\Programs\Xmind\Uninstall Xmind.exe" /currentuser` |
 | HKLM | Xmind 26.1.3145.63716 | XMIND LTD. | 26.1.3145.63716 | `Xmind_is1` | `C:\Program Files\Xmind\Uninstall Xmind.exe` |
 | HKLM | Xmind 26.1.3145.63716 | XMIND LTD. | 26.1.3145.63716 | `Xmind_is1` | `C:\Program Files\Xmind\uninstall.bat` |
 | HKLM | Xmind 26.1.7145.26621 | XMIND LTD. | 26.1.7145.26621 | `Xmind_is1` | `C:\Program Files\Xmind\uninstall.bat` |
