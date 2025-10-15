# Update MS Windows Desktop Runtime (Action) - Runtime engine for Microsoft .NET desktop applications update for all 64 bits version

The .NET Desktop Runtime enables you to run existing Windows desktop applications.

This package does not install the desktop runtime packages but simply updates them if needed (only 64 bits).
Please note that there are currently several versions, from version 5 to version 8.
The package scans your installation and updates only the runtimes required.

* Website : https://dotnet.microsoft.com/

* Direct download link : https://dotnet.microsoft.com/en-us/download/dotnet/8.0,
  https://dotnet.microsoft.com/en-us/download/dotnet/7.0,
  https://dotnet.microsoft.com/en-us/download/dotnet/6.0,
  https://dotnet.microsoft.com/en-us/download/dotnet/5.0,
* Silent install : https://silentinstallhq.com/net-desktop-runtime-8-0-silent-install-how-to-guide/


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Microsoft Windows Desktop Runtime - 6.0.29 (x64) | Microsoft Corporation | 48.116.12057 | `{A0DA3EDD-9C41-491F-A77E-5F90AFDB64B2}` | `MsiExec.exe /X{A0DA3EDD-9C41-491F-A77E-5F90AFDB64B2}` |
 | HKLM | Microsoft Windows Desktop Runtime - 6.0.29 (x64) | Microsoft Corporation | 6.0.29.33521 | `{54679abd-8ed9-4bd3-8400-7684dd7c6f03}` | `"C:\ProgramData\Package Cache\{54679abd-8ed9-4bd3-8400-7684dd7c6f03}\windowsdesktop-runtime-6.0.29-win-x64.exe"  /uninstall` |
 | HKLM | Microsoft Windows Desktop Runtime - 6.0.35 (x64) | Microsoft Corporation | 48.140.21525 | `{8AA69679-CCD6-42D9-BCDA-99BE386D57B7}` | `MsiExec.exe /X{8AA69679-CCD6-42D9-BCDA-99BE386D57B7}` |
 | HKLM | Microsoft Windows Desktop Runtime - 6.0.35 (x64) | Microsoft Corporation | 6.0.35.34113 | `{ed3bbfea-cc20-425e-b845-bc087d129675}` | `"C:\ProgramData\Package Cache\{ed3bbfea-cc20-425e-b845-bc087d129675}\windowsdesktop-runtime-6.0.35-win-x64.exe"  /uninstall` |
 | HKLM | Microsoft Windows Desktop Runtime - 7.0.18 (x64) | Microsoft Corporation | 56.72.12035  | `{F91C5C9A-FDEF-44D0-88D8-40113345FAA7}` | `MsiExec.exe /X{F91C5C9A-FDEF-44D0-88D8-40113345FAA7}` |
 | HKLM | Microsoft Windows Desktop Runtime - 7.0.18 (x64) | Microsoft Corporation | 7.0.18.33520 | `{9926fb6d-a007-472d-b0dc-38d7e8c475e0}` | `"C:\ProgramData\Package Cache\{9926fb6d-a007-472d-b0dc-38d7e8c475e0}\windowsdesktop-runtime-7.0.18-win-x64.exe"  /uninstall` |
 | HKLM | Microsoft Windows Desktop Runtime - 7.0.20 (x64) | Microsoft Corporation | 56.80.15245  | `{72C29BED-666F-4E5E-BC49-DF44C890742E}` | `MsiExec.exe /X{72C29BED-666F-4E5E-BC49-DF44C890742E}` |
 | HKLM | Microsoft Windows Desktop Runtime - 7.0.20 (x64) | Microsoft Corporation | 7.0.20.33720 | `{362ea044-f96f-45c7-b59f-0dbe5ca98ff4}` | `"C:\ProgramData\Package Cache\{362ea044-f96f-45c7-b59f-0dbe5ca98ff4}\windowsdesktop-runtime-7.0.20-win-x64.exe"  /uninstall` |
 | HKLM | Microsoft Windows Desktop Runtime - 8.0.4 (x64)  | Microsoft Corporation | 64.16.12024  | `{4B91040F-9192-4D51-B1CE-36B959846C8D}` | `MsiExec.exe /X{4B91040F-9192-4D51-B1CE-36B959846C8D}` |
 | HKLM | Microsoft Windows Desktop Runtime - 8.0.4 (x64)  | Microsoft Corporation | 8.0.4.33519  | `{93344293-35c0-4560-8a6c-1b06afd31de4}` | `"C:\ProgramData\Package Cache\{93344293-35c0-4560-8a6c-1b06afd31de4}\windowsdesktop-runtime-8.0.4-win-x64.exe"  /uninstall` |
 | HKLM | Microsoft Windows Desktop Runtime - 8.0.10 (x64) | Microsoft Corporation | 64.40.21605  | `{614C9740-3FD4-4788-A277-7C35CB4C323B}` | `MsiExec.exe /X{614C9740-3FD4-4788-A277-7C35CB4C323B}` |
 | HKLM | Microsoft Windows Desktop Runtime - 8.0.10 (x64) | Microsoft Corporation | 8.0.10.34118 | `{d990096d-6282-42c5-8d16-71272c5be274}` | `"C:\ProgramData\Package Cache\{d990096d-6282-42c5-8d16-71272c5be274}\windowsdesktop-runtime-8.0.10-win-x64.exe"  /uninstall` |
 | HKLM | Microsoft Windows Desktop Runtime - 8.0.14 (x64) | Microsoft Corporation | 64.56.29521  | `{BC56BEFC-D9B7-476F-9B7C-2CD494572C27}` | `MsiExec.exe /X{BC56BEFC-D9B7-476F-9B7C-2CD494572C27}` |
 | HKLM | Microsoft Windows Desktop Runtime - 8.0.14 (x64) | Microsoft Corporation | 8.0.14.34613 | `{f4c6fb4c-68da-475b-8e92-fd8e6f8960cd}` | `"C:\ProgramData\Package Cache\{f4c6fb4c-68da-475b-8e92-fd8e6f8960cd}\windowsdesktop-runtime-8.0.14-win-x64.exe"  /uninstall` |
 | HKLM | Microsoft Windows Desktop Runtime - 8.0.21 (x64) | Microsoft Corporation | 8.0.21.35325 | `{69a28bd2-b8bd-491a-a39d-5bcb13678463}` | `"C:\ProgramData\Package Cache\{69a28bd2-b8bd-491a-a39d-5bcb13678463}\windowsdesktop-runtime-8.0.21-win-x64.exe"  /uninstall` |
 | HKLM | Microsoft Windows Desktop Runtime - 8.0.21 (x64) | Microsoft Corporation | 64.84.40919 | `{A32777AD-F93A-4F26-BEE6-9C5961EA71D6}` | `MsiExec.exe /X{A32777AD-F93A-4F26-BEE6-9C5961EA71D6}` |
 | HKLM | Microsoft Windows Desktop Runtime - 8.0.21 (x86) | Microsoft Corporation | 8.0.21.35325 | `{a28e660a-e516-486f-9b6b-834d8e760ac1}` | `"C:\ProgramData\Package Cache\{a28e660a-e516-486f-9b6b-834d8e760ac1}\windowsdesktop-runtime-8.0.21-win-x86.exe"  /uninstall` |
 | HKLM | Microsoft Windows Desktop Runtime - 8.0.21 (x86) | Microsoft Corporation | 64.84.40919 | `{7D7A1D84-1363-4D33-B366-21F54AC4917D}` | `MsiExec.exe /X{7D7A1D84-1363-4D33-B366-21F54AC4917D}` |
