# Check WithSecure Hotfixes (Action) - Test the deployment of updates

The Check WithSecure Hotfixes is a free and open-source PowerShell script.
It tests whether all WithSecure hotfixes have been applied to the workstation.
Please note that WithSecure is a proprietary antivirus software and is in no way opensource.
Only this script is free.
It returns **0** in case of **success** (no error),
**100 + the number of hotfixes** detected in case of **error on hotfixes**
and **200** if the WithSecure software is **not installed**.

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
