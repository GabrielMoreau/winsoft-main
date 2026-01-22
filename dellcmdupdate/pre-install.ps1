
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

# Remove old version
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -notmatch $RefName) { Continue }

	$DisplayVersion = ToVersion $App.DisplayVersion
	$KeyProduct     = $Key.PSChildName

	If ($DisplayVersion -ge $RefVersion) { Continue }

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

################################################################

# View
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -notmatch $RefName) { Continue }

	$DisplayVersion = ToVersion $App.DisplayVersion
	$KeyProduct     = $Key.PSChildName
	Write-Output "Installed: $($App.DisplayName) / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
	# "Installed: {0,-56} / {1,-14} / {2} / {3}" -F $($App.DisplayName), $DisplayVersion, $KeyProduct, $($App.UninstallString)
}

################################################################

# Microsoft Windows Desktop Runtime
$WDRVersion8 = $Config.WDRVersion8
$RefName = 'Microsoft Windows Desktop Runtime'
$WindowsDesktopRuntime = $True

ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -notmatch $RefName) { Continue }

	$DisplayVersion = ToVersion $App.DisplayVersion
	$KeyProduct     = $Key.PSChildName
	$Uninstall = $App.UninstallString
	"Info: {0,-56} / {1,-14} / {2} / {3}" -F $($App.DisplayName), $DisplayVersion, $KeyProduct, $Uninstall

	# Only register Key with nice version number
	If ($Uninstall -match '^MsiExec.exe') { Continue }

	If ($App.DisplayName -match 'Runtime - 8\..*x64') {
		If ($DisplayVersion -lt (ToVersion($WDRVersion8))) {
			$WindowsDesktopRuntime = $True
		} Else {
			$WindowsDesktopRuntime = $False
			Write-Output "Note: $RefName already at version $DisplayVersion (>= $WDRVersion8)"
		}
	}
}

If ($WindowsDesktopRuntime -eq $True) {
	$Exe = "windowsdesktop-runtime-$WDRVersion8-win-x64.exe"
	$Args = '/install /quiet /norestart'
	If (Test-Path -Path "$Exe") {
		Write-Output "TryInstall: $RefName at version $WDRVersion8"
		Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name "$RefName"
	}
}

################################################################

# View
$ReturnCode = 0
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -notmatch $RefName) { Continue }

	$DisplayVersion = ToVersion $App.DisplayVersion
	$KeyProduct     = $Key.PSChildName
	Write-Output "Installed: $($App.DisplayName) / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
	# "Installed: {0,-56} / {1,-14} / {2} / {3}" -F $($App.DisplayName), $DisplayVersion, $KeyProduct, $($App.UninstallString)
}
Write-Output "ReturnCode: $ReturnCode"
Exit $ReturnCode
