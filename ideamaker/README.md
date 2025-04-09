# Raise3D ideaMaker - Slicer Software (3D printing)

ideaMaker is a slicing software from Raise3D which prepares 3D models for printing and turns them into G-Code file for your Raise3D printer.
See https://en.wikipedia.org/wiki/Slicer_(3D_printing).

* Website : https://www.raise3d.eu/
* Software : https://www.raise3d.com/ideamaker/

* Download : https://www.raise3d.eu/download/
* Silent install : NSIS

ideaMaker put an uninstall register key in hive `HKU` and not `HKLM`.
A script `uninstall.bat` has been added for a register key in `HKLM`.
Last version seems to put an uninstall key in `HKLM`.

## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | ideaMaker 5.0.6.8380 | Raise3D | 5.0.6.8380 | `ideaMaker` | `C:\Program Files\Raise3D\ideaMaker\uninstall.bat` |
 | HKLM | ideaMaker 5.0.6.8380 | Raise3D | 5.0.6.8380 | `ideaMaker-App` | `"C:\Program Files\Raise3D\ideaMaker-App\uninstall.exe"` |
 | HKLM | ideaMaker 5.1.2.8460 | Raise3D | 5.1.2.8460 | `ideaMaker` | `C:\Program Files\Raise3D\ideaMaker\uninstall.bat` |
 | HKLM | ideaMaker 5.1.2.8460 | Raise3D | 5.1.2.8460 | `ideaMaker-App` | `"C:\Program Files\Raise3D\ideaMaker-App\uninstall.exe"` |
 | HKLM | ideaMaker 5.2.2.8570 | Raise3D | 5.2.2.8570 | `ideaMaker` | `C:\Program Files\Raise3D\ideaMaker\uninstall.bat` |
 | HKLM | ideaMaker 5.2.2.8570 | Raise3D | 5.2.2.8570 | `ideaMaker-App` | `"C:\Program Files\Raise3D\ideaMaker-App\uninstall.exe"` |
