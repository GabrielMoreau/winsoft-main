# Zoom - Web Conference Client

Zoom Meetings is a proprietary video teleconferencing software program.

* Website : https://zoom.us/
* Wikipedia : https://en.wikipedia.org/wiki/Zoom_(software)

* Download : https://zoom.us/download
* Configuration : https://support.zoom.us/hc/fr/articles/201362163-Installation-et-configuration-de-masse-pour-Windows
* Silent install : https://silent-install.net/software/zoom/zoom/4.6.20033

Your need a configuration file `conf.yml` to specify your default zoom server at the installation.

See also for version number : https://www.zoom.us/rest/download?os=win,
	https://github.com/ScoopInstaller/Extras/blob/master/bucket/zoom.json


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Zoom Workplace (64-bit) | Zoom | 6.1.43316 | `{6FC53F6B-CC58-43A0-B23E-84B95825CBFE}` | `MsiExec.exe /X{6FC53F6B-CC58-43A0-B23E-84B95825CBFE}` |
