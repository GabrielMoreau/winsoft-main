
Write-Output "Begin Pre-Install"

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

# Get Config: Version
$Config = GetConfig -FilePath 'winsoft-config.ini'
$RefVersion = $Config.Version
$VCR20152022x64 = $Config.VCR20152022x64
Write-Output "Config: Version $RefVersion"
Write-Output "Config: VCR $VCR20152022x64"

$ToDo = 'unknown'

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If ($DisplayName -match 'Microsoft Visual .* Redistributable') {
			[version]$DisplayVersion = $App.DisplayVersion
			$KeyProduct = $Key | Split-Path -Leaf
			#Write-Output "# $DisplayName / $DisplayVersion / $KeyProduct"

			If ($DisplayName -match '2015-2022.*x64') {
				If (ToVersion($DisplayVersion) -lt ToVersion($VCR20152022x64)) {
					If ($ToDo -eq 'unknown') {
						$ToDo = 'install-2022'
					}
				} Else {
					Write-Output "Installed: Microsoft Visual C++ 2015-2022 (x64) redistributable $DisplayVersion"
					$ToDo = 'already-setup'
				}
			}
		}
	}

If ($ToDo -eq 'unknown') {
	$ToDo = 'install-2022'
}

If ($ToDo -eq 'install-2022') {
	$Exe = '2015-2022\vc_redist.x64.exe'
	$Args = '/install /quiet /norestart'
	If (Test-Path -Path "$Exe") {
		Write-Output "Update Microsoft Visual C++ 2015-2022 (x64) redistributable"
		Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name "VCR 2015-2022 x64"
	}
}

