# Skype - VoIP and Videoconferencing

Skype is a proprietary telecommunications application, best known for
VoIP-based videotelephony, videoconferencing and voice calls.
It also has instant messaging, file transfer, debit-based calls to
landline and mobile telephones (over traditional telephone networks),
and other features. 

* Website : https://www.skype.com/
* Wikipedia : https://en.wikipedia.org/wiki/Skype

* Download : https://www.skype.com/fr/get-skype/
* Silent install : https://silentinstallhq.com/skype-for-desktop-silent-install-how-to-guide/

Le fichier final n'a pas le même nom que le fichier initial.
Avec `wget`, il est possible d'avoir directement le fichier final.
wget --content-disposition  https://go.skype.com/windows.desktop.download

Il est possible d'avoir juste les en-tête et 0 ou 1 redirect afin d'avoir l'URL
dans laquelle on trouve le numéro de version.
wget --max-redirect=1 https://go.skype.com/windows.desktop.download 

Il suffit alors de faire la requête `curl` adapté.

Rappel : on utilise `curl` de préférence à `wget` afin de pouvoir faire
les commandes sous Linux ou sous MacOSX.
