# Update MS Visual Redistributable (Action) - Microsoft Visual C++ Redistributable Library update for all version

Many applications require the redistributable Visual C++ runtime library packages to function correctly.
These packages are often installed independently of applications,
allowing multiple applications to make use of the package while only having to install it once.

This package does not install the redistributable visual C++ packages but simply updates them if needed.

* Website : https://learn.microsoft.com/fr-fr/cpp/windows/latest-supported-vc-redist
* Wikipedia : https://en.wikipedia.org/wiki/Microsoft_Visual_C%2B%2B

* Direct download link : https://github.com/abbodi1406/vcredist
* Silent install : https://silentinstallhq.com/visual-c-redistributable-silent-install-master-list/

Last versions :
* folder 2005      -  6.0.2900.2180
* folder 2008      -  9.0.30729.5677
* folder 2010      - 10.0.40219.473
* folder 2012      - 11.0.61030.0
* folder 2013      - 12.0.40664.0
* folder 2015-2019 - 14.29.30153.0
* folder 2015-2022 - 14.44.35211.0

Version 2015-2019 is now replaced by version 2015-2022.

Have the version of an executable with `sigcheck.exe` or `peres` (natif):
```
Sysinternals\sigcheck.exe -a -h .\vcredist_ia64.exe
peres -v .\vcredist_ia64.exe | grep '^Product Version:'
```

Under GNU/Linux amd64
```bash
sudo dpkg --add-architecture i386 && sudo apt-get update && sudo apt-get install wine32
wine ~/Sysinternals/sigcheck.exe -a -h .\vcredist_ia64.exe
```

It's possible to automate
```bash
find tmp/ -name '*.exe' | xargs -r -n 1 wine ~/Sysinternals/sigcheck.exe -a -h | egrep '(Product|Prod version):' | cut -f 2 -d ':'
find tmp/ -name '*.exe' | xargs -r -n 1 peres -v | grep '^Product Version:' | awk '{print $3}'

find tmp/ -name '*.exe' | xargs -r  -I {} echo " \
		echo -n ' * '\$(echo {} | cut -f 2,3 -d '/' | sed -e \"s#/vc_*redist[_\.]#-#; s/.exe//;\")' ' ;
		echo \$(peres -v {} | grep '^Product Version:' | awk '{print \$3}')
		" \
	| bash
```

## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Microsoft VC++ redistributables repacked. | Intel Corporation | 12.0.0.0 | `{31D92EF6-075E-4BC8-8C0C-9265FD3EC624}` | `MsiExec.exe /I{31D92EF6-075E-4BC8-8C0C-9265FD3EC624}` |
 | HKLM | Microsoft VC++ redistributables repacked. | Intel Corporation | 12.0.0.0 | `{80BA3AFA-05DE-4771-AF68-A762E19E49DA}` | `MsiExec.exe /I{80BA3AFA-05DE-4771-AF68-A762E19E49DA}` |
 | HKLM | Microsoft Visual C++ 2005 Redistributable (x64) | Microsoft Corporation | 8.0.61000 | `{ad8a2fa1-06e7-4b0d-927d-6e54b3d31028}` | `MsiExec.exe /X{ad8a2fa1-06e7-4b0d-927d-6e54b3d31028}` |
 | HKLM | Microsoft Visual C++ 2008 Redistributable - x64 9.0.30729.17 | Microsoft Corporation | 9.0.30729 | `{8220EEFE-38CD-377E-8595-13398D740ACE}` | `MsiExec.exe /X{8220EEFE-38CD-377E-8595-13398D740ACE}` |
 | HKLM | Microsoft Visual C++ 2008 Redistributable - x64 9.0.30729.6161 | Microsoft Corporation | 9.0.30729.6161 | `{5FCE6D76-F5DC-37AB-B2B8-22AB8CEDB1D4}` | `MsiExec.exe /X{5FCE6D76-F5DC-37AB-B2B8-22AB8CEDB1D4}` |
 | HKLM | Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.6161 | Microsoft Corporation | 9.0.30729.6161 | `{9BE518E6-ECC6-35A9-88E4-87755C07200F}` | `MsiExec.exe /X{9BE518E6-ECC6-35A9-88E4-87755C07200F}` |
 | HKLM | Microsoft Visual C++ 2010  x64 Redistributable - 10.0.40219 | Microsoft Corporation | 10.0.40219 | `{1D8E6291-B0D5-35EC-8441-6616F567A0F7}` | `MsiExec.exe /X{1D8E6291-B0D5-35EC-8441-6616F567A0F7}` |
 | HKLM | Microsoft Visual C++ 2010  x86 Redistributable - 10.0.40219 | Microsoft Corporation | 10.0.40219 | `{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}` | `MsiExec.exe /X{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}` |
 | HKLM | Microsoft Visual C++ 2015-2022 Redistributable (x64) - 14.40.33810 | Microsoft Corporation | 14.40.33810.0 | `{5af95fd8-a22e-458f-acee-c61bd787178e}` | `"C:\ProgramData\Package Cache\{5af95fd8-a22e-458f-acee-c61bd787178e}\VC_redist.x64.exe"  /uninstall` |
 | HKLM | Microsoft Visual C++ 2015-2022 Redistributable (x86) - 14.40.33810 | Microsoft Corporation | 14.40.33810.0 | `{47109d57-d746-4f8b-9618-ed6a17cc922b}` | `"C:\ProgramData\Package Cache\{47109d57-d746-4f8b-9618-ed6a17cc922b}\VC_redist.x86.exe"  /uninstall` |
 | HKLM | Microsoft Visual C++ 2015-2022 Redistributable (x64) - 14.40.33816 | Microsoft Corporation | 14.40.33816.0 | `{77169412-f642-45e7-b533-0c6f48de12f9}` | `"C:\ProgramData\Package Cache\{77169412-f642-45e7-b533-0c6f48de12f9}\VC_redist.x64.exe"  /uninstall` |
 | HKLM | Microsoft Visual C++ 2015-2022 Redistributable (x86) - 14.40.33816 | Microsoft Corporation | 14.40.33816.0 | `{4373d0b5-4457-4a80-bad9-029de8df097b}` | `"C:\ProgramData\Package Cache\{4373d0b5-4457-4a80-bad9-029de8df097b}\VC_redist.x86.exe"  /uninstall` |
 | HKLM | Microsoft Visual C++ 2015-2022 Redistributable (x64) - 14.42.34433 | Microsoft Corporation | 14.42.34433.0 | `{804e7d66-ccc2-4c12-84ba-476da31d103d}` | `"C:\ProgramData\Package Cache\{804e7d66-ccc2-4c12-84ba-476da31d103d}\VC_redist.x64.exe"  /uninstall` |
 | HKLM | Microsoft Visual C++ 2015-2022 Redistributable (x86) - 14.42.34433 | Microsoft Corporation | 14.42.34433.0 | `{e7802eac-3305-4da0-9378-e55d1ed05518}` | `"C:\ProgramData\Package Cache\{e7802eac-3305-4da0-9378-e55d1ed05518}\VC_redist.x86.exe"  /uninstall` |
