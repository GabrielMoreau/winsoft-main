# VMware Workstation Player - Virtualization software for computers

VMware Player is a virtualization software package for x64 computers running Microsoft Windows or Linux.
VMware Player is available for personal non-commercial use.
You need a license for professional use.

* Website : https://www.vmware.com/
* Wikipedia : https://en.wikipedia.org/wiki/VMware_Workstation_Player

* Download : https://www.vmware.com/go/getplayer-win
* Silent install : https://docs.vmware.com/en/VMware-Workstation-Player-for-Windows/17.0/com.vmware.player.win.using.doc/GUID-85A967A8-7042-4F17-8116-7315B8F8E5A2.html,
  https://silentinstallhq.com/vmware-player-silent-install-how-to-guide/,
  https://docs.vmware.com/en/Horizon-FLEX/1.12/com.vmware.horizon.flex.admin.doc/GUID-000C012F-CBF6-4F63-A721-80D553F89CC1.html,
  https://docs.vmware.com/en/Horizon-FLEX/1.12/com.vmware.horizon.flex.admin.doc/GUID-000C012F-CBF6-4F63-A721-80D553F89CC1.html

Since Broadcom's acquisition of VMware, the product no longer appears to be available for free download. We strongly advise you to stop using it.

To uninstall silently
```bat
MsiExec.exe /x {XXXXXXXXXXXXXXXXXXX} /qn REBOOT=ReallySuppress REMOVE=ALL
```


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | VMware Player | VMware, Inc. | 17.5.1 | `{3157CAD1-F5B9-43CF-BE51-FAE72E7A576D}` | `` |
