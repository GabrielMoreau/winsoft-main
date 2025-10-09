# Mozilla Firefox - Web navigator

Firefox is a free and open-source web browser developed by the Mozilla Foundation.

* Website : https://www.mozilla.org
* Wikipedia : https://en.wikipedia.org/wiki/Firefox

* Download ESR : https://www.mozilla.org/fr/firefox/enterprise/#download
* Policies templates : https://github.com/mozilla/policy-templates/releases
* Silent install : https://support.mozilla.org/en-US/kb/deploy-firefox-msi-installers,
	https://silentinstallhq.com/mozilla-firefox-100-silent-install-how-to-guide/


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Mozilla Firefox ESR (x64 fr) | Mozilla | 115.14.0 | `Mozilla Firefox 115.14.0 ESR (x64 fr)` | `"C:\Program Files\Mozilla Firefox\uninstall\helper.exe"` |
 | HKLM | Mozilla Firefox ESR (x64 fr) | Mozilla | 115.15.0 | `Mozilla Firefox 115.15.0 ESR (x64 fr)` | `"C:\Program Files\Mozilla Firefox\uninstall\helper.exe"` |
 | HKLM | Mozilla Firefox ESR (x64 fr) | Mozilla | 128.4.0 | `Mozilla Firefox 128.4.0 ESR (x64 fr)` | `"C:\Program Files\Mozilla Firefox\uninstall\helper.exe"` |
 | HKLM | Mozilla Firefox ESR (x64 fr) | Mozilla | 128.7.0 | `Mozilla Firefox 128.7.0 ESR (x64 fr)` | `"C:\Program Files\Mozilla Firefox\uninstall\helper.exe"` |
 | HKLM | Mozilla Firefox ESR (x64 fr) | Mozilla | 140.3.1 | `Mozilla Firefox 140.3.1 ESR (x64 fr)` | `"C:\Program Files\Mozilla Firefox\uninstall\helper.exe"` |


## Policies

Policies can be specified by creating a file called policies.json.
See also: https://github.com/mozilla/policy-templates

For extension, you need to know the ID.
On method for example is to do
```bash
wget  -q https://addons.mozilla.org/firefox/downloads/latest/cookie-autodelete/latest.xpi
unzip -p latest.xpi manifest.json | grep 'id.:' ; rm latest.xpi
```
It's possible to validate the `policies.json` file with
```bash
cat policies.json | jq empty
```

You can see the deployed policies by using the URL about:policies


## Extensions

Some browser extensions are preinstalled, most of which are
security-related:
* Ublock Origin
* Cookie AutoDelete
* KeePassXC-Browser
* Grammalecte


## Extension F-secure

* https://help.f-secure.com/product.html#business/psb-portal/latest/en/task_DEB5ED2F1918438592921906DA2685F2-psb-portal-latest-en
* https://download.sp.f-secure.com/online-safety/fs_firefox_https.xpi

L'extension demande d'accepter ou de refuser des conditions d'utilisation.
Attention, ces conditions ne sont pas compatibles a priori avec le secret industriel.

> Nous vous demandons l'autorisation d'accéder aux informations suivantes
> sur les pages Web que vous consultez :
> * URL de la page Web, qui est envoyée à l'application de sécurité F-Secure
>   qui interroge le F-Secure Security Cloud sur la réputation de la page.
>
> En outre, nous vous demandons l'autorisation de collecter les données
> personnelles suivantes sur votre utilisation de la Protection de la
> navigation par F-Secure :
> * le motif du blocage d'une page Web, par exemple si elle est
>   dangereuse ou suspecte ;
> * informations relatives à la licence ;
> * le système d'exploitation, sa version et les identifiants uniques ;
> * la langue, l'emplacement et le modèle de l'appareil ;
> * l'URL de la page Web bloquée ;
>
> Ces données sont utilisées pour :
> * gérer, développer et améliorer les services et l'expérience client,
>   ainsi qu'à des fins de dépannage et de mesure des performances ;
> * améliorer les fonctionnalités des services et des pages Web connexes ;
> * fournir de l'aide et de l'assistance ;
>
> Si vous refusez que nous collections ces données, la Protection de la
> navigation par F-Secure ne peut pas bloquer les sites dangereux,
> protéger vos activités bancaires en ligne, ni afficher les évaluations
> des résultats de recherche. Pour plus d'informations sur les données
> que nous collectons et leur usage, consultez notre Politique de
> confidentialité.

Nous pouvons choisir `normal_installed` pour laisser l'utilisateur
choisir ou non d'accepter l'extension ou `blocked` pour empêcher son
installation.
