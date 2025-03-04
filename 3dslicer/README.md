# 3D Slicer - Visualization and analysis of medical image computing data sets

3D Slicer is a free, open source software for visualization, processing,
segmentation, registration, and analysis of medical, biomedical,and other
3D images and meshes; and planning and navigating image-guided procedures.
See https://en.wikipedia.org/wiki/Slicer_(3D_printing).

* Website : https://www.slicer.org/
* Wikipedia : https://en.wikipedia.org/wiki/3D_Slicer
* Documentation : https://slicer.readthedocs.io/en/latest/user_guide/about.html
* License : BSD-style
* Category : medical

* Download : https://download.slicer.org/


## Installer

NSIS installer, the classical `/S` flag could be use for silent install.
Slicer install in the user Windows HOME (`$HOME\AppData\Local\slicer.org\Slicer 5.4.0\`) and put an uninstall key in `HKU`.
You can change destination with flag `/D` (last parameter with no quote...).
Because of Slicer plugin's (share between users), it's seem better to use a folder writable by all users like `ProgramData`.
For exemple:
```
Slicer-5.4.0-win-amd64.exe /S /D=%ProgramData%\Slicer.org
```

To silent uninstall:
```
"%ProgramFiles%\Slicer.org\Uninstall.exe" /S
```

If install with `SYSTEM` account, the installer put a register uninstall key in `HKLM`.


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Slicer 5.4.0 | slicer.org | 5.4.0 | `Slicer 5.4.0 (Win64)` | `"C:\ProgramData\Slicer.org\Uninstall.exe"` |
 | HKLM | Slicer 5.6.0 | slicer.org | 5.6.0 | `Slicer 5.6.0 (Win64)` | `"C:\ProgramData\Slicer.org\Uninstall.exe"` |
 | HKLM | Slicer 5.6.1 | slicer.org | 5.6.1 | `Slicer 5.6.1 (Win64)` | `"C:\ProgramData\Slicer.org\Uninstall.exe"` |
 | HKLM | Slicer 5.8.0 | slicer.org | 5.8.0 | `Slicer 5.8.0 (Win64)` | `"C:\ProgramData\Slicer.org\Uninstall.exe"` |
 | HKLM | Slicer 5.8.1 | slicer.org | 5.8.1 | `Slicer 5.8.1 (Win64)` | `"C:\ProgramData\Slicer.org\Uninstall.exe"` |
