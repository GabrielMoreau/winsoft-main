# VisualRedist - Visual C++ Redistributable Library

Many applications require redistributable Visual C++ runtime library packages to function correctly.
These packages are often installed independently of applications,
allowing multiple applications to make use of the package while only having to install it once. 

This package does not install the redistributable visual C++ packages but simply updates them if needed.

* Wikipedia : https://en.wikipedia.org/wiki/Microsoft_Visual_C%2B%2B

* Direct download link : https://github.com/abbodi1406/vcredist
* Silent install : https://silentinstallhq.com/visual-c-redistributable-silent-install-master-list/

Last versions :
* folder 2008      -  9.0.30729.5677
* folder 2010      - 10.0.40219.473
* folder 2012      - 11.0.61030.0
* folder 2013      - 12.0.40664.0
* folder 2015-2019 - 14.29.30139.0
* folder 2015-2022 - 14.34.31938.0

Have the version of an executable with `sigcheck.exe` or `peres` (natif):
```
Sysinternals\sigcheck.exe -a -h .\vcredist_ia64.exe
peres -a .\vcredist_ia64.exe | egrep 'Product Version:'
```

Under GNU/Linux amd64
```
sudo dpkg --add-architecture i386 && sudo apt-get update && sudo apt-get install wine32
wine ~/Sysinternals/sigcheck.exe -a -h .\vcredist_ia64.exe
```

It's possible to automate
```bash
find tmp/ -name '*.exe' | xargs -r -n 1 wine ~/Sysinternals/sigcheck.exe -a -h | egrep '(Product|Prod version):' | cut -f 2 -d ':'
find tmp/ -name '*.exe' | xargs -r -n 1 peres -a | egrep 'Product Version:' | awk '{print $3}'
```

Example of package on a computer
```
# Microsoft Visual C++ 2008 Redistributable - x64 9.0.30729.6161     / 9.0.30729.6161 / {5FCE6D76-F5DC-37AB-B2B8-22AB8CEDB1D4}
# Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.6161     / 9.0.30729.6161 / {9BE518E6-ECC6-35A9-88E4-87755C07200F}
# Microsoft Visual C++ 2010  x86 Redistributable - 10.0.40219        / 10.0.40219     / {F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}
# Microsoft Visual C++ 2010  x64 Redistributable - 10.0.40219        / 10.0.40219     / {1D8E6291-B0D5-35EC-8441-6616F567A0F7}
# Microsoft VC++ redistributables repacked.                          / 12.0.0.0       / {847625FA-89A7-4EE0-8494-68A49BF977D6}
# Microsoft VC++ redistributables repacked.                          / 12.0.0.0       / {F0C8928A-BF8F-4AAF-B8BF-9CE865DBC711}
# Microsoft Visual C++ 2015-2019 Redistributable (x86) - 14.29.30139 / 14.29.30139.0  / {8d5fdf81-7022-423f-bd8b-b513a1050ae1}
# Microsoft Visual C++ 2015-2022 Redistributable (x64) - 14.31.31103 / 14.31.31103.0  / {2aaf1df0-eb13-4099-9992-962bb4e596d1}
# Microsoft Visual C++ 2017 Redistributable (x64) - 14.14.26429      / 14.14.26429.4
```
