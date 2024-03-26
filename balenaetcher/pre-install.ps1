
Write-Output "Begin Pre-Install"

$RefName = 'balenaEtcher'
$RefVersion = '__VERSION__'

Function ToVersion {
	Param (
		[Parameter(Mandatory = $true)] [string]$Version
	)

	$Version = $Version -Replace '[^\d\.].*$', ''
	$Version = $Version -Replace '\.00?$', ''
	$Version = $Version -Replace '\.00?$', ''
	Return [version]$Version
}

# Set HKU drive if not exists
New-PSDrive -PSProvider 'Registry' -Name 'HKU' -Root 'HKEY_USERS' -ErrorAction 'SilentlyContinue' | Out-Null

# Remove old version
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall";
  Get-ChildItem -Recurse 'HKU:\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall') |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf

		If ((ToVersion($DisplayVersion)) -ge (ToVersion($RefVersion))) { Return }

		If ($($App.UninstallString) -match 'balenaEtcher.exe"') {
			$UninstallSplit = $App.UninstallString -Split '"'
			$Exe = $UninstallSplit[1].Trim()
			$Args = '/S'
			Write-Output "Remove: $DisplayName / $DisplayVersion / $KeyProduct / $Exe $Args"
			If (!(Test-Path "$Exe")) {
				$KeyPath = $App.PSPath
				Write-Output "Warning: Remove Key $DisplayName / $DisplayVersion / $Exe / $KeyPath"
				Remove-Item -Path "$KeyPath" -Force -Recurse -ErrorAction SilentlyContinue
			}
		} Else { Return }

		$Proc = Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

		$Timeouted = $Null # Reset any previously set timeout
		# Wait up to 180 seconds for normal termination
		$Proc | Wait-Process -Timeout 300 -ErrorAction SilentlyContinue -ErrorVariable Timeouted
		If ($Timeouted) {
			# Terminate the process
			$Proc | Kill
			Write-Output "Error: kill $RefName uninstall exe"
			Return
		} ElseIf ($Proc.ExitCode -ne 0) {
			Write-Output "Error: $RefName uninstall return code $($Proc.ExitCode)"
			Return
		}
	}


# View
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall";
  Get-ChildItem -Recurse 'HKU:\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall') |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		Write-Output "Installed: $DisplayName / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
	}

# HKU	balenaEtcher 1.18.8	Balena Ltd.	1.18.8	d2f3b6c7-6f49-59e2-b8a5-f72e33900c2b	"C:\WINDOWS\system32\config\systemprofile\AppData\Local\Programs\balena-etcher\Uninstall balenaEtcher.exe" /currentuser
# HKLM	balenaEtcher 1.18.11	Balena Ltd.	1.18.11	balena-etcher	C:\Program Files\balena-etcher\uninstall.bat
