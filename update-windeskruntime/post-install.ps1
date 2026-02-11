
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

$Version5 = $Config.Version5
$Version6 = $Config.Version6
$Version7 = $Config.Version7
$Version8 = $Config.Version8

# Install last version
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -notmatch $RefName) { Continue }

	$DisplayVersion = ToVersion $App.DisplayVersion
	$KeyProduct     = $Key.PSChildName

	$DisplayName = $App.DisplayName
	$Uninstall = $App.UninstallString
	Write-Output "Info: $DisplayName / $DisplayVersion / $KeyProduct / $Uninstall"

	# Only register Key with nice version number
	If ($Uninstall -match '^MsiExec.exe') { Continue }

	If ($DisplayName -match 'Runtime - 5\..*x64') {
		If ($DisplayVersion -lt (ToVersion($Version5))) {
			$Exe = 'windowsdesktop-runtime-$Version5-win-x64.exe'
			$Args = '/install /quiet /norestart'
			If (Test-Path -Path "$Exe") {
				Write-Output "Warn: Update $RefName $DisplayVersion to version $Version5"
				Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name "$RefName $Version5"
			}
		} Else {
			Write-Output "Note: $RefName already at version $DisplayVersion (>= $Version5)"
		}
	}
	ElseIf ($DisplayName -match 'Runtime - 6\..*x64') {
		If ($DisplayVersion -lt (ToVersion($Version6))) {
			$Exe = 'windowsdesktop-runtime-$Version6-win-x64.exe'
			$Args = '/install /quiet /norestart'
			If (Test-Path -Path "$Exe") {
				Write-Output "Warn: Update $RefName $DisplayVersion to version $Version6"
				Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name "$RefName $Version6"
			}
		} Else {
			Write-Output "Note: $RefName already at version $DisplayVersion (>= $Version6)"
		}
	}
	ElseIf ($DisplayName -match 'Runtime - 7\..*x64') {
		If ($DisplayVersion -lt (ToVersion($Version7))) {
			$Exe = 'windowsdesktop-runtime-$Version7-win-x64.exe'
			$Args = '/install /quiet /norestart'
			If (Test-Path -Path "$Exe") {
				Write-Output "Warn: Update $RefName $DisplayVersion to version $Version7"
				Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name "$RefName $Version7"
			}
		} Else {
			Write-Output "Note: $RefName already at version $DisplayVersion (>= $Version7)"
		}
	}
	ElseIf ($DisplayName -match 'Runtime - 8\..*x64') {
		If ($DisplayVersion -lt (ToVersion($Version8))) {
			$Exe = 'windowsdesktop-runtime-$Version8-win-x64.exe'
			$Args = '/install /quiet /norestart'
			If (Test-Path -Path "$Exe") {
				Write-Output "Warn: Update $RefName $DisplayVersion to version $Version8"
				Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name "$RefName $Version8"
			}
		} Else {
			Write-Output "Note: $RefName already at version $DisplayVersion (>= $Version8)"
		}
	}
}

########################################################################

# View
$ReturnCode = 0
$OutPuts = @()
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -notmatch $RefName) { Continue }

	$DisplayVersion = ToVersion $App.DisplayVersion
	$KeyProduct     = $Key.PSChildName
	$OutPuts += "Installed: {0,-56} / {1,-14} / {2} / {3}" -F $App.DisplayName, $DisplayVersion, $KeyProduct, $App.UninstallString
}
$OutPuts | Sort-Object
Write-Output "ReturnCode: $ReturnCode"
Exit $ReturnCode

# Microsoft Windows Desktop Runtime - 6.0.29 (x64)                   / 48.116.12057   / {A0DA3EDD-9C41-491F-A77E-5F90AFDB64B2} / MsiExec.exe /X{A0DA3EDD-9C41-491F-A77E-5F90AFDB64B2}
# Microsoft Windows Desktop Runtime - 6.0.29 (x64)                   / 6.0.29.33521   / {54679abd-8ed9-4bd3-8400-7684dd7c6f03} / "C:\ProgramData\Package Cache\{54679abd-8ed9-4bd3-8400-7684dd7c6f03}\windowsdesktop-runtime-6.0.29-win-x64.exe"  /uninstall
# Microsoft Windows Desktop Runtime - 7.0.18 (x64)                   / 56.72.12035    / {F91C5C9A-FDEF-44D0-88D8-40113345FAA7} / MsiExec.exe /X{F91C5C9A-FDEF-44D0-88D8-40113345FAA7}
# Microsoft Windows Desktop Runtime - 7.0.18 (x64)                   / 7.0.18.33520   / {9926fb6d-a007-472d-b0dc-38d7e8c475e0} / "C:\ProgramData\Package Cache\{9926fb6d-a007-472d-b0dc-38d7e8c475e0}\windowsdesktop-runtime-7.0.18-win-x64.exe"  /uninstall
# Microsoft Windows Desktop Runtime - 8.0.4 (x64)                    / 64.16.12024    / {4B91040F-9192-4D51-B1CE-36B959846C8D} / MsiExec.exe /X{4B91040F-9192-4D51-B1CE-36B959846C8D}
# Microsoft Windows Desktop Runtime - 8.0.4 (x64)                    / 8.0.4.33519    / {93344293-35c0-4560-8a6c-1b06afd31de4} / "C:\ProgramData\Package Cache\{93344293-35c0-4560-8a6c-1b06afd31de4}\windowsdesktop-runtime-8.0.4-win-x64.exe"  /uninstall
