
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

# From SWMB code

# Enable
Function TweakEnableUpgradesOnUnsupportedHard { # RESINFO
	Write-Output "Enabling Windows 11 upgrades with unsupported hardware..."
	If ([System.Environment]::OSVersion.Version.Build -ge 22000) {
		[cultureinfo]::CurrentUICulture='en-US'
		$CheckTPM_Version = (Get-Tpm).ManufacturerVersionFull20
		If (($CheckTPM_Version -like '*not supported*') -Or ($CheckTPM_Version -like '*non pris*')) {
			Write-Output ' TPM not 2.0 - registry bypass force'
			If (!(Test-Path 'HKLM:\SYSTEM\Setup\MoSetup')) {
				New-Item -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Force | Out-Null
			}
			Set-ItemProperty -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Name 'AllowUpgradesWithUnsupportedTPMOrCPU' -Type DWord -Value 1
		}
	}
}

# View
Function TweakViewUpgradesOnUnsupportedHard { # RESINFO
	Write-Output "Viewing Windows 11 upgrades with unsupported hardware (0 or not exist: Disable, 1: Enable)..."
	If ([System.Environment]::OSVersion.Version.Build -ge 22000) {
		Get-ItemProperty -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Name 'AllowUpgradesWithUnsupportedTPMOrCPU'
	} Else {
		Write-Output " Operating system not running Windows 11 or higher"
	}
}

########################################################################

Checkpoint-Computer -Description "Checkpoint before installing KB5054156" -RestorePointType MODIFY_SETTINGS
Write-Output "Checkpoint created"

TweakEnableUpgradesOnUnsupportedHard
TweakViewUpgradesOnUnsupportedHard

# $URL = 'https://catalog.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/fa84cc49-18b2-4c26-b389-90c96e6ae0d2/public/windows11.0-kb5054156-x64_a0c1638cbcf4cf33dbe9a5bef69db374b4786974.msu'
# $MSU = "$Env:Temp\KB5054156.msu"
# Invoke-WebRequest -Uri $URL -OutFile $MSU

$MSU = "KB5054156.msu"

$Exe = 'wusa.exe'
$Args = "`"$MSU`" /quiet /norestart"
Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name "KB5054156" -Timeout 1200

Get-HotFix -Id KB5054156

$ReturnCode = [System.Environment]::OSVersion.Version.Build
If (dism.exe /Online /Get-Packages /Format:Table | Select-String 'KB5054156.*Installed') {
	$ReturnCode = 0
}

########################################################################

Write-Output "ReturnCode: $ReturnCode"
Exit $ReturnCode
