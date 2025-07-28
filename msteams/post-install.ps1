Write-Output "Begin Post-Install"

Write-Host "`nChecking for Microsoft Teams (MSIX version) installation..."

$installed = $false

# Check if installed for current user
$userPackages = Get-AppxPackage -Name "*Teams*" -ErrorAction SilentlyContinue
if ($userPackages) {
	Write-Host "Teams is installed for the current user:"
	$userPackages | Format-Table Name, Version -AutoSize
	$installed = $true
} else {
	Write-Host "Teams is NOT installed for the current user."
}

# Check for provisioned packages (system-wide)
$globalPackages = Get-ProvisionedAppxPackage -Online | Where-Object DisplayName -like "*Teams*"
if ($globalPackages) {
	Write-Host "`nTeams is provisioned system-wide:"
	$globalPackages | Format-Table DisplayName, Version -AutoSize
	$installed = $true
} else {
	Write-Host "`nTeams is NOT provisioned system-wide."
}

if ($installed) {
	Write-Host "`nResult: Microsoft Teams is installed or available for automatic installation."
	exit 0
} else {
	Write-Host "`nResult: Microsoft Teams (MSIX version) is NOT detected."
	exit 1
}
