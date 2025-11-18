# Chrome - Google Chrome navigator

Google Chrome is a cross-platform web browser developed by Google.

* Website : https://www.google.com/chrome/
* Wikipedia : https://www.wikipedia.org/wiki/Google_Chrome

* Download : https://chromeenterprise.google/intl/fr_fr/browser/download/
* Silent install : https://www.get-itsolutions.com/silent-install-google-chrome-and-disable-auto-update/
* Silent uninstall : https://gist.github.com/craysiii/50042edceb2ff77288558eb6b930dab9,
  https://www.itninja.com/question/how-to-uninstall-any-version-google-chrome-there-is-no-uninstall-string-how-to-identify-the-version-and-uninstall-by-path-appdata-google-version-uninstall

## Extensions

* GPO : https://support.google.com/chrome/a/topic/6242754
* Extension policies https://support.google.com/chrome/a/answer/7532015

Some browser extensions are preinstalled, most of which are security-related:
* Ublock Origin
* Cookie AutoDelete
* KeePassXC-Browser
* Decentraleyes
* ClearURLs


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Google Chrome | Google LLC | 125.0.6422.142 | `{9113689C-73CB-3186-A887-E2631880E11F}` | `MsiExec.exe /X{9113689C-73CB-3186-A887-E2631880E11F}` |
 | HKLM | Google Chrome | Google LLC | 141.0.7390.66  | `{25CA3DD2-ABE2-3644-9BB1-653047FE4EA2}` | `MsiExec.exe /X{25CA3DD2-ABE2-3644-9BB1-653047FE4EA2}` |
 | HKLM | Google Chrome | Google LLC | 141.0.7390.108 | `{F0E131DE-2158-352E-90D4-7B523C706959}` | `MsiExec.exe /X{F0E131DE-2158-352E-90D4-7B523C706959}` |
 | HKLM | Google Chrome | Google LLC | 142.0.7444.176 | `{0AA2C178-BF99-3F72-BA87-F6123A1A95C8}` | `MsiExec.exe /X{0AA2C178-BF99-3F72-BA87-F6123A1A95C8}` |
