Write-Output "Begin Post-Install"

Write-Host "`nChecking For Microsoft Teams (MSIX Version) Installation..."

$IsInstalled = $False

# Check If Installed For Current User
$UserPackages = Get-AppxPackage -Name "*Teams*" -ErrorAction SilentlyContinue
If ($UserPackages) {
	Write-Host "Teams Is Installed For The Current User:"
	$UserPackages | Format-Table Name, Version -AutoSize
	$IsInstalled = $True
} Else {
	Write-Host "Teams Is NOT Installed For The Current User."
}

# Check For Provisioned Packages (System-Wide)
$GlobalPackages = Get-ProvisionedAppxPackage -Online | Where-Object DisplayName -Like "*Teams*"
If ($GlobalPackages) {
	Write-Host "`nTeams Is Provisioned System-Wide:"
	$GlobalPackages | Format-Table DisplayName, Version -AutoSize
	$IsInstalled = $True
} Else {
	Write-Host "`nTeams Is NOT Provisioned System-Wide."
}

If ($IsInstalled) {
	Write-Host "`nResult: Microsoft Teams Is Installed Or Available For Automatic Installation."
	Exit 0
} Else {
	Write-Host "`nResult: Microsoft Teams (MSIX Version) Is NOT Detected."
	Exit 1
}
