
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Output ("Begin Pre-Install [$TimeStamp]`n" + "=" * 39 + "`n")

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

# Remove Teams Machine-Wide Installer
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -match 'Teams Machine-Wide Installer') {
		$DisplayVersion = ToVersion $App.DisplayVersion
		$KeyProduct     = $Key.PSChildName
		$UninstallSplit = $App.UninstallString -Split "/I"
		$Exe = 'MsiExec.exe'
		$Args = '/x "' + $UninstallSplit[1].Trim() + '" /qn /norestart'
		Write-Output "Info1: $DisplayName / $DisplayVersion / $KeyProduct/ $Args"
		Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name 'Teams Machine-Wide Installer'
	}
}

$LogDir = [Environment]::ExpandEnvironmentVariables($Config.LogDir)
Write-Output "Info: Log dir $LogDir"

# Remove Microsoft Teams Meeting Add-in for Microsoft Office
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -match 'Microsoft Teams Meeting Add-in for Microsoft Office') {
		$DisplayVersion = ToVersion $App.DisplayVersion
		$KeyProduct     = $Key.PSChildName
		$UninstallSplit = $App.UninstallString -Split "/I"
		$Exe = 'MsiExec.exe'
		$Args = '/x "' + $UninstallSplit[1].Trim() + '" /quiet InstallerVersion=v3 /l "$LogDir\MSTeams-PreInstall-MSI.log"'
		Write-Output "Info2: $DisplayName / $DisplayVersion / $KeyProduct/ $Args"
		Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name 'Microsoft Teams Meeting Add-in for Microsoft Office'
	}
}

# Remove previous Appx Package
Get-AppxPackage -Name MSTeams -AllUsers | Remove-AppxPackage -AllUsers

########################################################################

# View
$ReturnCode = 0
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -notmatch $RefName) { Continue }

	$DisplayVersion = ToVersion $App.DisplayVersion
	$KeyProduct     = $Key.PSChildName
	Write-Output "Installed: $($App.DisplayName) / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
}
Write-Output "ReturnCode: $ReturnCode"
Exit $ReturnCode
