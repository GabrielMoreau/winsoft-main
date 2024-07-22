# Check WithSecure Hotfixes (Action) - Test the deployment of updates

The Check WithSecure Hotfixes is a free and open-source PowerShell script.
It tests whether all WithSecure hotfixes have been applied to the workstation.
Please note that WithSecure is a proprietary antivirus software and is in no way opensource.
Only this script is free.

* It returns **0** in case of **success** (no error),
* the **number of uninstalled hotfixes bits** in the event of a hotfixe error,
* and **1024** if the WithSecure software is **not installed**.

The error code tells you which hotfixes have not been applied (see example below).
The hotfixes error mapping table is very simple:

 | Id | Hotfixe Match        | Bit | URL                                                                 |
 | --:|:-------------------- | ---:|:------------------------------------------------------------------- |
 |  1 | `WSBS1600-HF01`      |   1 | https://download.withsecure.com/corpro/cs/cs16.00/WSBS1600-HF01.jar |
 |  2 | `WithSecure Hotfix2` |   2 | https://download.withsecure.com/corpro/cs/cs16.00/WSBS1600-HF02.jar |
 |  3 | `WSBS1600-HF03`      |   4 | https://download.withsecure.com/corpro/cs/cs16.00/WSBS1600-HF03.jar |
 |  4 | `WSBS1600-HF04`      |   8 | https://download.withsecure.com/corpro/cs/cs16.00/WSBS1600-HF04.jar |
 |  5 | `WSBS1600-HF05`      |  16 | https://download.withsecure.com/corpro/cs/cs16.00/WSBS1600-HF05.jar |
 |  6 | `WSBS1600-HF06`      |  32 | https://download.withsecure.com/corpro/cs/cs16.00/WSBS1600-HF06.jar |

Example: if hotfixes 2 and 5 are not applied, the error code is 18 (2+16).
You must then go to the WithSecure console and push back again the hotfixes indicated (here 2 and 5) on this computer.

The script can be run many times on a workstation,
it's fast and doesn't modify the computer's operation in any way.
All it does (not completely) is read registry keys.

* Website : https://www.withsecure.com/
* Wikipedia : https://en.wikipedia.org/wiki/F-Secure

* Download : https://www.withsecure.com/en/support/product-support/business-suite/client-security (Hotfixes - JAR file)
* WithSecure Business Suite : https://www.withsecure.com/en/support/product-support/business-suite/

## Adding hotfixes to your console

Once you've downloaded the hotfixes from the publisher's website (see link above), you need to import them into the server via the console.
In the `root` folder of all machines (regardless of OS), go to the `installations` tab.
Then click on `Installation packages`, and you'll see a window with an `import` button.

To push one or more hotfixes onto a machine or the whole park, go back to the `installations` tab, selecting either the `root` folder or the machine(s), and click `Install`.
You must then select a hotfix and confirm with `Ok`.
This step must be repeated for each hotfix! Fortunately, there are a maximum of 6.
Once you've finished, remember to `Distribute strategies` on the park (or machine).

If a hotfix turns out not to have been pushed on a machine, it must be pushed again.
The software has no problem with this.

## License and Copyright

* License [MIT](../LICENSE.md)
* Copyright (C) 2021-2024, LEGI UMR 5519 / CNRS UGA G-INP, Grenoble, France
* Authors :
    * Gabriel MOREAU <Gabriel.Moreau(A)univ-grenoble-alpes.fr>
    * David PARYL <David.Paryl(A)lcc-toulouse.fr>
