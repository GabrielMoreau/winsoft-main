# Mozilla Thunderbird - Mail reader

Thunderbird is a free and open-source email reader developed by the Mozilla Foundation.

* Website : https://www.thunderbird.net/
* Wikipedia : https://en.wikipedia.org/wiki/Mozilla_Thunderbird

* Download : https://www.thunderbird.net/en-US/thunderbird/all/
* Silent install : https://enterprise.thunderbird.net/deploy/deploy-thunderbird-with-msi-installers


## Installer Command Line Options

https://firefox-source-docs.mozilla.org/browser/installer/windows/installer/FullConfig.html


## Policies

Policies can be specified by creating a file called policies.json.
See also: https://github.com/mozilla/policy-templates

For extension, you need to know the ID.
On method for example is to do
```bash
curl -# -L 'https://addons.thunderbird.net/thunderbird/downloads/latest/grammalecte-fr-thunderbird/latest.xpi' -o grammalecte-fr-thunderbird-latest.xpi
unzip -p grammalecte-fr-thunderbird-latest.xpi manifest.json | grep 'id.:' ; rm grammalecte-fr-thunderbird-latest.xpi
```
It's possible to validate the `policies.json` file with
```bash
cat policies.json | jq empty
```

You can see the deployed policies by using the URL about:policies


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Mozilla Thunderbird (x64 fr) | Mozilla | 128.0   | `Mozilla Thunderbird 128.0 (x64 fr)`   | `"C:\Program Files\Mozilla Thunderbird\uninstall\helper.exe"` |
 | HKLM | Mozilla Thunderbird (x64 fr) | Mozilla | 143.0.1 | `Mozilla Thunderbird 143.0.1 (x64 fr)` | `"C:\Program Files\Mozilla Thunderbird\uninstall\helper.exe"` |
