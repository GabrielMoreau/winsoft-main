# Run Reboot if pending (Action) - Restart computer if actions in progress remain pending

This is a free and open-source script under CC0 license ([Creative Common Zero](https://spdx.org/licenses/CC0-1.0)).

Deploying this application locally enables you to restart this computer if actions are in progress.
It can be used, for example, to remotely reboot computers that have forgotten to be restarted by their primary user after a major update.

Warning: the application returns a zero error code (0) if the workstation is not restarted.
If the workstation is rebooted, bitlocker is temporarily deactivated on the system partition for a single reboot, and the error code corresponds to the number of the test performed in the [pre-install](./pre-install.ps1) script.
There are 7 tests to determine whether or not to reboot the computer.
The list below gives a simplified view:

1. `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending`
1. `HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootInProgress`
1. `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired`
1. `HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackagesPending`
1. `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\PostRebootReporting`
1. `HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations`
1. `HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations2`
1. `HKLM:\SOFTWARE\Microsoft\Updates`
1. `HKLM:\SOFTWARE\Microsoft\ServerManager\CurrentRebootAttemps`
