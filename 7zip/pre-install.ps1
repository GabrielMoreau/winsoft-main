
$RefName = '7-Zip'

# Remove old 7-Zip (not x64)
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		If ($DisplayName -match '(x64 edition)') { Return } # only 32 bit
		If (!($App.UninstallString -match 'MsiExec.exe')) { Return } # only msi

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		
		$UninstallSplit = $App.UninstallString -Split "/I"
		$Args = '/x "' + $UninstallSplit[1].Trim() + '" /qn /norestart'
		Write-Output "Remove: $DisplayName / $DisplayVersion / $KeyProduct / $Args"

		$Proc = Start-Process -FilePath "msiexec.exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

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
