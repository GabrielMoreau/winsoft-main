# Telegram Messenger - Desktop Instant messaging application

Telegram Desktop is free and open-source an instant messaging
application client with a focus on speed and security.
The application also provides optional end-to-end encrypted chats and
video calling, VoIP, file sharing and several other features.

* Website : https://telegram.org/
* Wikipedia : https://en.wikipedia.org/wiki/Telegram_(software)

* Download : https://github.com/telegramdesktop/tdesktop
* Silent install : https://silentinstallhq.com/telegram-desktop-silent-install-how-to-guide/

We use the portable version, which we install in `ProgramFiles` in
order to have a global installation for all users. The official setup
installs the software under the user's profile and sets a key in the
user's registry. This is not what we want.


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Telegram Desktop 5.11.1 | Telegram FZ-LLC | 5.11.1 | `Telegram Desktop` | `C:\Program Files\Telegram Desktop\uninstall.bat` |
 | HKLM | Telegram Desktop 5.12.3 | Telegram FZ-LLC | 5.12.3 | `Telegram Desktop` | `C:\Program Files\Telegram Desktop\uninstall.bat` |
 | HKLM | Telegram Desktop 6.1.4  | Telegram FZ-LLC | 6.1.4  | `Telegram Desktop` | `C:\Program Files\Telegram Desktop\uninstall.bat` |
