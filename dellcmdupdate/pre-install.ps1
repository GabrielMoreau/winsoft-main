
Write-Output "Begin Pre-Install"

# Get Config from file
Function GetConfig {
	Param (
		[Parameter(Mandatory = $True)] [string]$FilePath
	)

	Return Get-Content "$FilePath" | Where-Object { $_ -Match '=' } | ForEach-Object { $_ -Replace "#.*", "" } | ForEach-Object { $_ -Replace "\\", "\\" } | ConvertFrom-StringData
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

# Get Config: Version
$Config = GetConfig -FilePath 'winsoft-config.ini'
$RefVersion = $Config.Version
$RefName = 'Dell Command . Update'
Write-Output "Config: Version $RefVersion"

# Remove old version
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf

		If ($DisplayVersion -ge [version]$RefVersion) { Return }

		If ($($App.UninstallString) -match 'MsiExec.exe') {
			$Exe = 'MsiExec.exe'
			$Args = '/x "' + $KeyProduct + '" /qn'
			Write-Output "Remove: $DisplayName / $DisplayVersion / $KeyProduct / $Exe $Args"
		} Else {
			$UninstallSplit = ($App.UninstallString -Split "exe")[0] -Replace '"', ''
			$Exe = $UninstallSplit + 'exe'
			$Args = '/S /x /v/qn'
			Write-Output "Remove: $DisplayName / $DisplayVersion / $($App.UninstallString) / $Exe $Args"
		}

		Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name "$RefName"
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
		"Installed: {0,-56} / {1,-14} / {2} / {3}" -F $DisplayName, $DisplayVersion, $KeyProduct, $($App.UninstallString)
	}


################################################################

# Microsoft Windows Desktop Runtime
$RefName = 'Microsoft Windows Desktop Runtime'
$WindowsDesktopRuntime = $True

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		$Uninstall = $App.UninstallString
		"Info: {0,-56} / {1,-14} / {2} / {3}" -F $DisplayName, $DisplayVersion, $KeyProduct, $Uninstall

		# Only register Key with nice version number
		If ($Uninstall -match '^MsiExec.exe') { Return }

		If ($DisplayName -match 'Runtime - 8\..*x64') {
			If ((ToVersion($DisplayVersion)) -lt (ToVersion('__VERSION8__'))) {
				$WindowsDesktopRuntime = $True
			} Else {
				$WindowsDesktopRuntime = $False
				Write-Output "Note: $RefName already at version $DisplayVersion (>= __VERSION8__)"
			}
		}
	}

If ($WindowsDesktopRuntime == $True) {
	$Exe = 'windowsdesktop-runtime-__VERSION8__-win-x64.exe'
	$Args = '/install /quiet /norestart'
	If (Test-Path -Path "$Exe") {
		Write-Output "TryInstall: $RefName at version __VERSION8__"
		Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name "$RefName"
	}
}

# View all version
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		$Exe = $App.UninstallString
		"Installed: {0,-56} / {1,-14} / {2} / {3}" -F $DisplayName, $DisplayVersion, $KeyProduct, $Exe
	} | Sort-Object
