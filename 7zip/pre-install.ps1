
Write-Output "Begin Pre-Install"

$RefName = '7-Zip'

# Remove old 7-Zip
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		If (!($App.UninstallString -match 'MsiExec.exe')) { Return } # only msi

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf

		$UninstallSplit = $App.UninstallString -Split "/I"
		$Args = '/x "' + $UninstallSplit[1].Trim() + '" /qn /norestart'
		Write-Output "Remove: $DisplayName / $DisplayVersion / $KeyProduct / $Args"

		$Proc = Start-Process -FilePath "MsiExec.exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

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
			#If ($Proc.ExitCode -eq 1612) {
			#	Write-Output "Warning: no clean uninstall procedure"
			#	If (Test-Path -Path "${Env:ProgramFiles}\7-Zip") {
			#		Remove-Item -LiteralPath "${Env:ProgramFiles}\7-Zip" -Force -Recurse -ErrorAction SilentlyContinue
			#	}
			#	Remove-Item -Path $Key.PSPath -Verbose -Force -Recurse -ErrorAction SilentlyContinue
			#}
			Return
		}
	}
