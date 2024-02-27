
Write-Output "Begin Post-Install"

# Clean old duplicate key with 7-Zip in the name (same uninstall string)

$RefVersion = '__VERSION__'
$RefVersionShort='__VERSIONSHORT__'
$RefUninstallString = ''
$RefName = '7-Zip'

Function ToVersion {
	Param (
		[Parameter(Mandatory = $true)] [string]$Version
	)

	$Version = $Version -Replace '[^\d\.].*$', ''
	$Version = $Version -Replace '\.00?$', ''
	$Version = $Version -Replace '\.00?$', ''
	Return [version]$Version
}

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$App = (Get-ItemProperty -Path $_.PSPath)
		$DisplayName = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }
		$DisplayVersion = $App.DisplayVersion
		$Exe = $App.UninstallString
		Write-Output "Key Item: $Name $DisplayName $DisplayVersion $Exe"
		If ((ToVersion($DisplayVersion)) -eq (ToVersion($RefVersion))) {
			$RefUninstallString = $Exe
			$KeyPath = $App.PSPath
			Write-Output "Ref Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath"
			}
	}

If ($RefUninstallString -ne '') {
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
		ForEach {
			$App = (Get-ItemProperty -Path $_.PSPath)
			$DisplayName = $App.DisplayName
			If (!($DisplayName -match $RefName)) { Return }
			$DisplayVersion = $App.DisplayVersion
			$Exe = $App.UninstallString
			Write-Output "Check Key: $DisplayName : $DisplayVersion < $RefVersion ?"
			If (($Exe -eq $RefUninstallString) -And ((ToVersion($DisplayVersion)) -lt (ToVersion($RefVersion)))) {
				$KeyPath = $App.PSPath
				Write-Output "Remove Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath"
				Remove-Item -Path "$KeyPath" -Force -Recurse -ErrorAction SilentlyContinue
			}
		}
}

$SoftInstalled = $False
# Test if installed
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If ($DisplayName -match $RefName) {
			$SoftInstalled = $True
			Return
		}
	}
If ($SoftInstalled -eq $False) {
	$Exe = "7z$RefVersionShort-x64.exe"
	$Args = "/S"
	Write-Output "Install Exe: $Exe $Args"
	$Proc = Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

	$Timeouted = $Null # Reset any previously set timeout
	# Wait up to 180 seconds for normal termination
	$Proc | Wait-Process -Timeout 300 -ErrorAction SilentlyContinue -ErrorVariable Timeouted
	If ($Timeouted) {
		# Terminate the process
		$Proc | Kill
		Write-Output "Error: kill $RefName install"
	} ElseIf ($Proc.ExitCode -ne 0) {
		Write-Output "Error: $RefName install return code $($Proc.ExitCode)"
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
		Write-Output "View: $DisplayName / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
	}
