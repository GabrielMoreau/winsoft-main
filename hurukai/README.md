# Hurukai-Agent - HarfangLab EDR agent

Hurukai is an EDR agent developed by HarfangLab.
Endpoint detection and response (EDR) is a cybersecurity technology that continually monitors an "endpoint" (e.g. mobile phone, desktop, laptop) to mitigate malicious cyber threats.

* Website : https://harfanglab.io/

You need to define a `winsoft-conf` folder at the same level as your `winsoft-main` source folder, then the `/_common/conf.mk` file in it to define your site parameters for the installer.

The parameters are as follows:
```
HURUKAI_SERVER:=hurukai.example.com
HURUKAI_SIG:=blabla
HURUKAI_PASSWORD:=youragentpass
```

In parallel, you need to put the `agent-X.Y.Z_x64.msi` installation MSI in this `hurukai` folder.
Be careful not to archive this MSI on a forge like GitLab.
It is proprietary software.
Under no circumstances should you publish a version on the Internet. 

Please note that the Key Product in the registry changes with each version.


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | HarfangLab Hurukai agent | HarfangLab | 3.10.3 | `{B671C117-C0D7-494C-850B-C4A1D9E18E5C}` | `MsiExec.exe /X{B671C117-C0D7-494C-850B-C4A1D9E18E5C}` |
 | HKLM | HarfangLab Hurukai agent | HarfangLab | 3.11.6 | `{0311C5BF-D71D-4F48-AE2B-83187706B792}` | `MsiExec.exe /X{0311C5BF-D71D-4F48-AE2B-83187706B792}` |
