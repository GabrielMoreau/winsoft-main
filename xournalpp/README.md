# Xournal++ - PDF annotate and hand note-taking software

Xournal++ is a free and open-source hand note-taking software written
in C++ with the target of flexibility, functionality and speed.
It is used to annotate a pdf document to add marks, comments,
highlight some passages or make some corrections.
Particularly useful when you are proofreading and you want to send some
remarks on the document. The edited document can be exported in the
Xournal format for further editing or as a pdf to embed the annotations.

* Website : https://github.com/xournalpp/xournalpp
* Wikipedia : https://en.wikipedia.org/wiki/Xournal
* Framasoft : https://framalibre.org/content/xournal

* Download : https://github.com/xournalpp/xournalpp/releases/latest

Because we're installing this software under the SYSTEM account, which
doesn't really have a profile, we need to manually create a shortcut in
the global menu and add a registry key to uninstall Xournal++
(see https://github.com/xournalpp/xournalpp/issues/4445).


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKU | Xournal++ | The Xournal++ Team | 1.2.3 | `Xournal++` | `"C:\Program Files\Xournal++\Uninstall.exe"` |
 | HKU | Xournal++ | The Xournal++ Team | 1.2.4 | `Xournal++` | `"C:\Program Files\Xournal++\Uninstall.exe"` |
 | HKLM | Xournal++ | The Xournal++ Team | 1.2.5 | `Xournal++` | `"C:\Program Files\Xournal++\Uninstall.exe"` |
 | HKLM | Xournal++ | The Xournal++ Team | 1.2.6 | `Xournal++` | `"C:\Program Files\Xournal++\Uninstall.exe"` |
