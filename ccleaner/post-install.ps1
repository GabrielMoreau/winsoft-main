
Write-Output "Begin Post-Install"

# Copy ini file and fix right for all user
ForEach ($ProgramPath in "${Env:ProgramFiles}\CCleaner", "${Env:ProgramFiles(x86)}\CCleaner") {
	If (Test-Path "$ProgramPath") {
		Write-Output "Copy config file"
		#Copy-Item "ccleaner-all.ini" -destination "$ProgramPath\CCleaner-all.ini"
		#Copy-Item "ccleaner-user.ini" -destination  "$ProgramPath\CCleaner-user.ini"
		Copy-Item "ccleaner.ini" -Destination  "$ProgramPath\CCleaner.ini"

		ICACLS $ProgramPath /grant utilisateurs:m /t /c /q
	}
}

# Remove desktop shortcuts
If (Test-Path "${Env:USERPROFILE}\Desktop\CCleaner.lnk" -PathType leaf) {
	Write-Output "Remove desktop shortcuts in USERPROFILE"
	Remove-Item -Path "${Env:USERPROFILE}\Desktop\CCleaner.lnk"
}

If (Test-Path "C:\Users\Public\Desktop\CCleaner.lnk" -PathType leaf) {
	Write-Output "Remove desktop shortcuts in Users/Public"
	Remove-Item -Path "C:\Users\Public\Desktop\CCleaner.lnk"
}
