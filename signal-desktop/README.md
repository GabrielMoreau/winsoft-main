# Signal-Desktop - Encrypted instant messaging, voice, and video calls

Signal-Desktop is a free and open-source encrypted messaging service for instant messaging, voice, and video calls.
The instant messaging function includes sending text, voice notes, images, videos, and other files.
Communication may be one-to-one between users or may involve group messaging.

* Website : https://signal-desktop.org/
* Wikipedia : https://en.wikipedia.org/wiki/Signal_(software)
* Forge : https://github.com/signalapp/Signal-Desktop

* Download : https://signal.org/fr/download/windows/
* Silent install : https://silentinstallhq.com/signal-silent-install-how-to-guide/,
	http://wapt.tranquil.it/store/fr/tis-signal-desktop/,
	https://www.reddit.com/r/SCCM/comments/tmh5g7/has_anyone_found_a_way_to_deploy_signal_for/


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKU | Signal 6.43.2 | Signal Messenger, LLC | 6.43.2 | `7d96caee-06e6-597c-9f2f-c7bb2e0948b4` | `"C:\WINDOWS\system32\config\systemprofile\AppData\Local\Programs\signal-desktop\Uninstall Signal.exe" /currentuser` |
 | HKCU | Signal 7.32.0 | Signal Messenger, LLC | 7.32.0 | `7d96caee-06e6-597c-9f2f-c7bb2e0948b4` | `"C:\Users\XXXXX\AppData\Local\Programs\signal-desktop\Uninstall Signal.exe" /currentuser` |
 | HKCU | Signal 7.33.0 | Signal Messenger, LLC | 7.33.0 | `7d96caee-06e6-597c-9f2f-c7bb2e0948b4` | `"C:\Users\XXXXX\AppData\Local\Programs\signal-desktop\Uninstall Signal.exe" /currentuser` |
 | HKLM | Signal 7.33.0 | Signal Messenger, LLC | 7.33.0 | `7d96caee-06e6-597c-9f2f-c7bb2e0948b4` | `C:\ProgramData\signal-desktop\uninstall.bat` |
 | HKCU | Signal 7.46.1 | Signal Messenger, LLC | 7.46.1 | `7d96caee-06e6-597c-9f2f-c7bb2e0948b4` | `"C:\Users\XXXXX\AppData\Local\Programs\signal-desktop\Uninstall Signal.exe" /currentuser` |
 | HKLM | Signal 7.46.1 | Signal Messenger, LLC | 7.46.1 | `7d96caee-06e6-597c-9f2f-c7bb2e0948b4` | `C:\ProgramData\signal-desktop\uninstall.bat` |
