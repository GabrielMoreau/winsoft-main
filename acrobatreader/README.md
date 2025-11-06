# AcrobatReader - Adobe PDF reader

Adobe Acrobat is a family of application software to view, create,
manipulate, print and manage PDF files.

* Website : https://www.adobe.com/
* Wikipedia : https://en.wikipedia.org/wiki/Adobe_Acrobat

* Download https://get.adobe.com/reader/enterprise/
* Silent install : https://silentinstallhq.com/adobe-reader-dc-silent-install-how-to-guide/

The package now includes the latest version of the installer (`AcroRdrDCx64XXXXXXXXXX_MUI.exe`)
and the update (`AcroRdrDCx64UpdXXXXXXXXXX.msp`),
where `XXXXXXXXXX` is the version number.
This makes installation more complex.

* If a newer or identical version is already installed on the computer, nothing is installed.
* If an older version is installed on the computer, the update is installed.
* If Acrobat is not installed on the computer, the normal installation is performed.

The package is therefore twice as large, as it contains two installers.

Please note the following points during installation:

* Automatic updates are disabled and stopped via the `AdobeARMservice` service.
* Adobe Collaboration is disabled by renaming the `AdobeCollabSync.exe` binary to `AdobeCollabSync.exe.org`.


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Adobe Acrobat (64-bit) | Adobe | 24.002.20687 | `{AC76BA86-1036-1033-7760-BC15014EA700}` | `MsiExec.exe /I{AC76BA86-1036-1033-7760-BC15014EA700}` |
 | HKLM | Adobe Acrobat (64-bit) | Adobe | 24.002.20759 | `{AC76BA86-1036-1033-7760-BC15014EA700}` | `MsiExec.exe /I{AC76BA86-1036-1033-7760-BC15014EA700}` |
 | HKLM | Adobe Acrobat (64-bit) | Adobe | 24.004.20243 | `{AC76BA86-1036-1033-7760-BC15014EA700}` | `MsiExec.exe /I{AC76BA86-1036-1033-7760-BC15014EA700}` |
 | HKLM | Adobe Acrobat (64-bit) | Adobe | 24.004.20272 | `{AC76BA86-1036-1033-7760-BC15014EA700}` | `MsiExec.exe /I{AC76BA86-1036-1033-7760-BC15014EA700}` |
 | HKLM | Adobe Acrobat (64-bit) | Adobe | 24.005.20392 | `{AC76BA86-1036-1033-7760-BC15014EA700}` | `MsiExec.exe /I{AC76BA86-1036-1033-7760-BC15014EA700}` |
 | HKLM | Adobe Acrobat (64-bit) | Adobe | 24.005.20399 | `{AC76BA86-1036-1033-7760-BC15014EA700}` | `MsiExec.exe /I{AC76BA86-1036-1033-7760-BC15014EA700}` |
 | HKLM | Adobe Acrobat (64-bit) | Adobe | 25.001.20756 | `{AC76BA86-1036-1033-7760-BC15014EA700}` | `MsiExec.exe /I{AC76BA86-1036-1033-7760-BC15014EA700}` |
 | HKLM | Adobe Acrobat (64-bit) | Adobe | 25.001.20813 | `{AC76BA86-1036-1033-7760-BC15014EA700}` | `MsiExec.exe /I{AC76BA86-1036-1033-7760-BC15014EA700}` |
