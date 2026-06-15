
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Output ("Begin Pre-Install [$TimeStamp]`n" + "=" * 39 + "`n")

########################################################################

$Drive = (Get-CimInstance Win32_OperatingSystem).SystemDrive + "\"
$State = Get-ComputerRestorePoint -ErrorAction SilentlyContinue
Try {
	Enable-ComputerRestore -Drive $Drive -ErrorAction SilentlyContinue
} Catch {
	Write-Output "System Restore may already be enabled or not available"
}

Checkpoint-Computer -Description "Checkpoint before cleaning WinSxS" -RestorePointType MODIFY_SETTINGS

Write-Output "Checkpoint created"
$ReturnCode = 0

########################################################################

Write-Output "ReturnCode: $ReturnCode"
Exit $ReturnCode
