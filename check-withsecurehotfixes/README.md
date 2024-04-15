# Check WithSecure Hotfixes (Action) - Test the deployment of updates

The Check WithSecure Hotfixes is a free and open-source PowerShell script.
It tests whether all WithSecure hotfixes have been applied to the workstation.
Please note that WithSecure is a proprietary antivirus software and is in no way opensource.
Only this script is free.
It returns **0** in case of **success** (no error),
the **number of uninstalled hotfixes bits** in the event of a hotfixe error,
and **1024** if the WithSecure software is **not installed**.
The error code tells you which hotfixes have not been applied (see example below).
The hotfixes error mapping table is very simple:

 | Hotfixe              | Bit |
 |:-------------------- | ---:|
 | `WSBS1600-HF01`      |   1 |
 | `WithSecure Hotfix2` |   2 |
 | `WSBS1600-HF03`      |   4 |
 | `WSBS1600-HF04`      |   8 |
 | `WSBS1600-HF05`      |  16 |
 | `WSBS1600-HF06`      |  32 |

Example: if hotfixes 2 and 5 are not applied, the error code is 18.
You must then go to the WithSecure console and push back again the hotfixes indicated (here 2 and 5) on this computer.

The script can be run many times on a workstation,
it's fast and doesn't modify the computer's operation in any way.

* Website : https://www.withsecure.com/
* Wikipedia : https://en.wikipedia.org/wiki/F-Secure

* Download : https://www.withsecure.com/en/support/product-support/business-suite/client-security (Hotfixes - JAR file)
* WithSecure Business Suite : https://www.withsecure.com/en/support/product-support/business-suite/


## License and Copyright

* License [MIT](../LICENSE.md)
* Copyright (C) 2021-2024, LEGI UMR 5519 / CNRS UGA G-INP, Grenoble, France
* Authors :
    * Gabriel MOREAU <Gabriel.Moreau(A)univ-grenoble-alpes.fr>
    * David PARYL <David.Paryl(A)lcc-toulouse.fr>
