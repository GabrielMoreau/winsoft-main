
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

########################################################################

$UninstallKeys = @(
	'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
	'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
)

########################################################################


# Get Config: Version
$Config = GetConfig -FilePath 'winsoft-config.ini'
$RefVersion = ToVersion $Config.Version
$RefName = 'Mozilla Thunderbird'
Write-Output "Config: Version $RefVersion"

# Clean old duplicate key with Firefox in the name (same uninstall string)
$RefUninstallString = ''
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	$DisplayName = $App.DisplayName
	If (!($DisplayName -match $RefName)) { Continue }
	$DisplayVersion = ToVersion $App.DisplayVersion
	$Exe = $App.UninstallString
	$KeyPath = $App.PSPath
	If ($DisplayVersion -eq $RefVersion) {
		$RefUninstallString = $Exe
		Write-Output "Ref Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath"
	} Else {
		Write-Output "Other Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath"
	}
}

If ($RefUninstallString -ne '') {
	ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
		$App = Get-ItemProperty -Path $Key.PSPath
		$DisplayName = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Continue }
		$DisplayVersion = ToVersion $App.DisplayVersion
		$Exe = $App.UninstallString
		$KeyPath = $App.PSPath
		# Echo "Check Key $DisplayName : $DisplayVersion < $RefVersion ?"
		If ((($Exe -eq $RefUninstallString) -Or ($Exe -eq $Null)) -And ($DisplayVersion -lt $RefVersion)) {
			Write-Output "Remove Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath"
			Remove-Item -Path "$KeyPath" -Force -Recurse -ErrorAction SilentlyContinue
		} Else {
			Write-Output "Keep Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath / $DisplayVersion"
		}
	}
}

# View
$ReturnCode = 143
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -notmatch $RefName) { Continue }

	$DisplayVersion = ToVersion $App.DisplayVersion
	$KeyProduct     = $Key.PSChildName
	Write-Output "Installed: $($App.DisplayName) / $DisplayVersion / $KeyProduct / $($App.UninstallString)"

	If ($DisplayVersion -gt $RefVersion) {
		$ReturnCode = [Math]::Min($ReturnCode, 141)
	} ElseIf ($DisplayVersion -eq $RefVersion) {
		$ReturnCode = 0
	} Else {
		$ReturnCode = [Math]::Min($ReturnCode, 142)
	}
}
Write-Output "ReturnCode: $ReturnCode"
Exit $ReturnCode
