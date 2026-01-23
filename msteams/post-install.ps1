
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Output ("`nBegin Post-Install [$TimeStamp]`n" + "=" * 40 + "`n")

########################################################################

# Get Config from file
Function GetConfig {
	Param (
		[Parameter(Mandatory = $True)] [string]$FilePath
	)

	Return Get-Content "$FilePath" | Where-Object { $_ -Match '=' } | ForEach-Object { $_ -Replace "#.*", "" } | ForEach-Object { $_ -Replace "\\", "\\" } | ConvertFrom-StringData
}

# Transform string to a version object
Function ToVersion {
	Param (
		[Parameter(Mandatory = $true)] [string]$Version
	)

	$Version = $Version -Replace '[^\d\.].*$', ''
	$Version = "$Version.0.0.0"
	$Version = $Version -Replace '\.+',     '.'
	$Version = $Version -Replace '\.0+',    '.0'
	$Version = $Version -Replace '\.0(\d)', '.$1'
	$Version = $Version.Split('.')[0,1,2,3] -Join '.'
	Return [version]$Version
}

# Run MSI or EXE with timeout control
Function Run-Exec {
	Param (
		[Parameter(Mandatory = $True)] [string]$Name,
		[Parameter(Mandatory = $True)] [string]$FilePath,
		[Parameter(Mandatory = $True)] [string]$ArgumentList,
		[Parameter(Mandatory = $False)] [int]$Timeout = 300
	)

	$Proc = Start-Process -FilePath "$FilePath" -ArgumentList "$ArgumentList" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

	$Timeouted = $Null # Reset any previously set timeout
	# Wait up to 180 seconds for normal termination
	$Proc | Wait-Process -Timeout $Timeout -ErrorAction SilentlyContinue -ErrorVariable Timeouted
	If ($Timeouted) {
		# Terminate the process
		$Proc | Kill
		Write-Output "Error: kill $Name uninstall exe"
		Return
	} ElseIf ($Proc.ExitCode -ne 0) {
		Write-Output "Error: $Name uninstall return code $($Proc.ExitCode)"
		Return
	}
}

########################################################################

$UninstallKeys = @(
	'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
	'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
)

########################################################################

# Get Config: Version
$Config = GetConfig -FilePath 'winsoft-config.ini'
$RefVersion = ToVersion $Config.Version
$RefName = $Config.RegexSearch
Write-Output "Config:`n * Version: $RefVersion`n * RegexSearch: $RefName"

########################################################################
# Put your specific code here

Write-Host "`nChecking For Microsoft Teams (MSIX Version) Installation..."

$IsInstalled = $False
$ReturnCode = 0

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
} Else {
	Write-Host "`nResult: Microsoft Teams (MSIX Version) Is NOT Detected."
	$ReturnCode = 143
}

########################################################################

# View
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -notmatch $RefName) { Continue }

	$DisplayVersion = ToVersion $App.DisplayVersion
	$KeyProduct     = $Key.PSChildName
	Write-Output "Installed: $($App.DisplayName) / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
}
Write-Output "ReturnCode: $ReturnCode"
Exit $ReturnCode
