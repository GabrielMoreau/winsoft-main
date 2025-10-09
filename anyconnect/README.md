# Cisco AnyConnect - Secure Client AnyConnect VPN suite

Cisco AnyConnect Secure Mobility Client is a proprietary VPN client
for connecting to Cisco VPN concentrators.

* Website : https://www.cisco.com/c/en/us/security/vpn-endpoint-security-clients/
* Wikipedia : https://fr.wikipedia.org/wiki/Cisco_AnyConnect_Secure_Mobility_Client,
  https://en.wikipedia.org/wiki/Cisco_Systems_VPN_Client (old)

* Download : https://nomadisme.grenet.fr/

Manually download the `anyconnect-win-4.XXXX-core-vpn-webdeploy-k9.msi` file (version 4)
or `cisco-secure-client-win-5.XXXX-core-vpn-webdeploy-k9.msi` (version 5)
in the current folder and remember to update the version number in the `Makefile`.

For this installer, we have not found a way to automate this task.


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Cisco AnyConnect Secure Mobility Client | Cisco Systems, Inc. | 4.10.07061 | `{11E16B39-0FA6-4DF0-9736-73BB638C9924}` | `MsiExec.exe /X{11E16B39-0FA6-4DF0-9736-73BB638C9924}` |
 | HKLM | Cisco AnyConnect Secure Mobility Client  | Cisco Systems, Inc. | 4.10.07061 | `Cisco AnyConnect Secure Mobility Client` | `C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\Uninstall.exe -remove` |
 | HKLM | Cisco Secure Client - AnyConnect VPN | Cisco Systems, Inc. | 5.1.5.65 | `{87318E2B-E234-4750-9032-15A7C2C8D242}` | `MsiExec.exe /X{87318E2B-E234-4750-9032-15A7C2C8D242}` |
 | HKLM | Cisco Secure Client - AnyConnect VPN  | Cisco Systems, Inc. | 5.1.5.65 | `Cisco Secure Client - AnyConnect VPN` | `C:\Program Files (x86)\Cisco\Cisco Secure Client\Uninstall.exe -remove` |
