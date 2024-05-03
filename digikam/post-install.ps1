
Write-Output "Begin Post-Install"

# Clean old duplicate key with digiKam in the name (same uninstall string)

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

# Get Config: Version
$Config = GetConfig -FilePath 'winsoft-config.ini'
$RefVersion = $Config.Version
$RefUninstallString = ''
$RefName = 'digiKam'
Write-Output "Config: Version $RefVersion"

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	Where { $_.Name -match "$RefName" } |
	ForEach {
		$App = (Get-ItemProperty -Path $_.PSPath)
		$DisplayVersion = $App.DisplayVersion
		$Exe = $App.UninstallString
		$DisplayName = $App.DisplayName
		If ((ToVersion($DisplayVersion)) -eq (ToVersion($RefVersion))) {
			$RefUninstallString = $Exe
			$KeyPath = $App.PSPath
			Write-Output "Ref Key: $DisplayName / $Exe / $KeyPath"
			}
	}

If ($RefUninstallString -ne '') {
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
		Where { $_.Name -match "$RefName" } |
		ForEach {
			$App = (Get-ItemProperty -Path $_.PSPath)
			$DisplayVersion = $App.DisplayVersion
			$Exe = $App.UninstallString
			$DisplayName = $App.DisplayName
			# Echo "Check Key $DisplayName : $DisplayVersion < $RefVersion ?"
			If (($Exe -eq $RefUninstallString) -And ((ToVersion($DisplayVersion)) -lt (ToVersion($RefVersion)))) {
				$KeyPath = $App.PSPath
				Write-Output "Remove Key: $DisplayName / $Exe / $KeyPath"
				Remove-Item -Path "$KeyPath" -Force -Recurse -ErrorAction SilentlyContinue
			}
		}
}

# View
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		Write-Output "Installed: $DisplayName / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
	}
