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


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | HarfangLab Hurukai agent | HarfangLab | 3.10.3 | `{B671C117-C0D7-494C-850B-C4A1D9E18E5C}` | `MsiExec.exe /X{B671C117-C0D7-494C-850B-C4A1D9E18E5C}` |
