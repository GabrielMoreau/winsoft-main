# VMware Horizon Client - Client for VDI VMware Horizon (virtual desktop)

VMware Horizon Clients allow you to connect to your VMware Horizon
virtual desktop from your device of choice giving you on-the-go access
from any location.

Since Broadcom's acquisition of VMware, EUC products have been resold and are now distributed by Omnissa.
For the moment, the name remains unchanged.

* Website : https://customerconnect.omnissa.com/
* Wikipedia : https://en.wikipedia.org/wiki/VMware_Horizon

* Download : https://customerconnect.omnissa.com/downloads/info/slug/desktop_end_user_computing/vmware_horizon_clients/horizon_8
* Silent install : https://silentinstallhq.com/vmware-horizon-client-silent-install-how-to-guide/

You should manually check regularly for updates to the Horizon client at https://customerconnect.omnissa.com/downloads/info/slug/desktop_end_user_computing/vmware_horizon_clients/horizon_8
and copy the link of the last Horizon client into the file [url.txt](./url.txt).
If you have a script to get the URL of the latest client version, please share it.


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | VMware Horizon Client | VMware, Inc. | 8.12.1.44700 | `{6143E07B-39E7-42C7-85FF-FDB0693443DC}` | `MsiExec.exe /X{6143E07B-39E7-42C7-85FF-FDB0693443DC}` |
 | HKLM | VMware Horizon Client | VMware, Inc. | 8.12.1.44700 | `{92345b76-93b7-4ee3-8541-db7a7df619e5}` | `"C:\ProgramData\Package Cache\{92345b76-93b7-4ee3-8541-db7a7df619e5}\VMware-Horizon-Client-2312.1-8.12.1-23531249.exe"  /uninstall` |
 | HKLM | VMware Horizon HTML5 Multimedia Redirection Client | VMware, Inc. | 8.12.1 | `{26084D90-0229-4757-B609-CEC89B4BEE3A}` | `MsiExec.exe /X{26084D90-0229-4757-B609-CEC89B4BEE3A}` |
 | HKLM | VMware Horizon Media Redirection for Microsoft Teams | VMware, Inc. | 8.12.1 | `{595EF4D8-03AA-4486-BC12-F8F5F8450A59}` | `MsiExec.exe /X{595EF4D8-03AA-4486-BC12-F8F5F8450A59}` |
 | HKLM | VMware Horizon Client | VMware, Inc. | 8.13.0.8174 | `{147a1ba1-cef1-4bc3-a42b-eba5a0982f32}` | `"C:\ProgramData\Package Cache\{147a1ba1-cef1-4bc3-a42b-eba5a0982f32}\VMware-Horizon-Client-2406-8.13.0-9986028157.exe"  /uninstall` |
 | HKLM | VMware Horizon Client | VMware, Inc. | 8.13.0.8174 | `{7E49B95B-6B8A-4B4D-A35D-9ACB64F40AFC}` | `MsiExec.exe /X{7E49B95B-6B8A-4B4D-A35D-9ACB64F40AFC}` |
 | HKLM | VMware Horizon HTML5 Multimedia Redirection Client | VMware, Inc. | 8.13.0 | `{59E2D1A4-36AE-4393-88FF-9FE9CD8493AC}` | `MsiExec.exe /X{59E2D1A4-36AE-4393-88FF-9FE9CD8493AC}` |
