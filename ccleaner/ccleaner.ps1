
#
# CCleaner
#

$Process = "ccleaner"

# stop processus
If (Get-Process $Process -ea 0) {
	Stop-Process -name $Process
}


# silent install
.\ccsetup-__SOFTVERSION__.exe /S /L=1036 | Out-Null


# copy ini file and fix right for all user
ForEach ($ProgramPath in "${Env:ProgramFiles}\CCleaner", "${Env:ProgramFiles(x86)}\CCleaner") {
	If (Test-Path "$ProgramPath") {
		# Fichier config
		#Copy-Item "ccleaner-all.ini" -destination "$ProgramPath\CCleaner-all.ini"
		#Copy-Item "ccleaner-user.ini" -destination  "$ProgramPath\CCleaner-user.ini"
		Copy-Item "ccleaner.ini" -Destination  "$ProgramPath\CCleaner.ini"

		ICACLS $ProgramPath /grant utilisateurs:m /t /c /q
	}
}


# remove desktop shortcuts
If (Test-Path "${Env:USERPROFILE}\Desktop\CCleaner.lnk" -PathType leaf) {
	Remove-Item -path "${Env:USERPROFILE}\Desktop\CCleaner.lnk"
}

If (Test-Path "C:\Users\Public\Desktop\CCleaner.lnk" -PathType leaf) {
	Remove-Item -path "C:\Users\Public\Desktop\CCleaner.lnk"
}
