# AnyDesk - Remote desktop application

AnyDesk is a remote desktop application.
The proprietary software program provides platform independent remote access to personal computers and other devices running the host application.
It offers remote control, file transfer, and VPN functionality.
AnyDesk is often used in technical support scams and other remote access scams.

* Website : https://anydesk.com/
* Wikipedia : https://en.wikipedia.org/wiki/AnyDesk

* Download : https://inkscape.org/release/inkscape-dev/?latest=1
* Silent install : https://support.anydesk.com/knowledge/command-line-interface-for-windows
  https://silentinstallhq.com/anydesk-silent-install-how-to-guide/


## Silent install

{{{
MsiExec.exe /i AnyDesk.msi /qn /L*v "C:\Temp\AnyDesk.log"
AnyDesk.exe --start-with-win --create-shortcuts --remove-first --update-disabled --silent --install "%ProgramFiles(x86)%\AnyDesk"
}}}


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | AnyDesk MSI | AnyDesk Software GmbH | 8.0.5     | `{62853EBF-E9DD-4AA5-B20A-5A6C3DD74FF3}` | `MsiExec.exe /X{62853EBF-E9DD-4AA5-B20A-5A6C3DD74FF3}` |
 | HKLM | AnyDesk MSI | AnyDesk Software GmbH | 8.0.13    | `{62853EBF-E9DD-4AA5-B20A-5A6C3DD74FF3}` | `MsiExec.exe /X{62853EBF-E9DD-4AA5-B20A-5A6C3DD74FF3}` |
 | HKLM | AnyDesk     | AnyDesk Software GmbH | ad 8.0.14 | `AnyDesk` | `"C:\Program Files (x86)\AnyDesk\AnyDesk.exe" --uninstall` | 
