# Dell Bios Utility (Uninstall) - DBUtil Removal Utility following Dell Security Advisory DSA-2021-088 and DSA-2021-152

This update provides a remedy for Dell Security Advisory
[DSA-2021-088](https://www.dell.com/support/kbdoc/en-us/000186019/dsa-2021-088-dell-client-platform-security-update-for-an-insufficient-access-control-vulnerability-in-the-dell-dbutil-driver)
and [DSA-2021-152](https://www.dell.com/support/kbdoc/en-us/000190105/dsa-2021-152-dell-client-platform-security-update-for-an-insufficient-access-control-vulnerability-in-the-dell-dbutildrv2-sys-driver).
It will detect and uninstall the `dbutil_2_3.sys` driver and versions 2.5 and 2.6 of the `DBUtilDrv2.sys` driver from the system.

* Website : https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=8gg09&lwp=rt
* Download : https://dl.dell.com/FOLDER07604649M/3/DBUtil-Removal-Utility_8GG09_WIN_2.5.0_A03_02.EXE

Download and extract EXE : `DBUtilRemovalTool.exe`

Options:
 - `/?`  - Shows command line options
 - `/s`  - Silent mode execution. Suppresses user prompts.
 - `/i`  - Interactive mode execution.
 - `/w`  - Search System drive (including System Drive this is default option)
 - `/r`  - To Add Removable drives (If Present) to the Scan
 - `/n`  - To Scan Network and Cloud Drives
 - `/l=<Log file Full Path>` - Log Application Messages to File.
