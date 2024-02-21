
Write-Output "Begin Pre-Install"

$RefName = 'VLC media player'
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

		If ((ToVersion($DisplayVersion)) -ge (ToVersion($RefVersion))) { Return }

		If ($($App.UninstallString) -match 'MsiExec.exe') {
			$Exe = 'msiexec.exe'
			$Args = '/x "' + $KeyProduct + '" /qn'
			Write-Output "Remove MSI: $DisplayName / $DisplayVersion / $KeyProduct / $Exe $Args"
		} Else {
			$UninstallSplit = $App.UninstallString -Split "exe"
			$Exe = $UninstallSplit[0] + 'exe"'
			$Args = '/S'
			Write-Output "Remove EXE: $DisplayName / $DisplayVersion / $($App.UninstallString) / $Exe $Args"
		}

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

# View: VLC media player / 3.0.20 / VLC media player / "C:\Program Files\VideoLAN\VLC\uninstall.exe"
