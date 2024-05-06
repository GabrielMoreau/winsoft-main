
Write-Output "`n   SSHFS-Win-Connect`n"
Write-Output   "   Associate a network drive with a SSHFS file system (connection to an SSH or SFTP server)."
Write-Output   "   This script uses the Winfsp driver and the SSHFS-Win program.`n"
Write-Output   "   This very simple script was written by Gabriel Moreau"
Write-Output   "   Copyright (C) 2022, LEGI, CNRS, France`n"

# Get Config from file
Function GetConfig {
	Param (
		[Parameter(Mandatory = $True)] [string]$FilePath
	)

	Return Get-Content "$FilePath" | Where-Object { $_ -Match '=' } | ForEach-Object { $_ -Replace "#.*", "" } | ForEach-Object { $_ -Replace "\\", "\\" } | ConvertFrom-StringData
}

# Get Config: Version
$Config = GetConfig -FilePath "$Env:ProgramFiles\SSHFS-Win\sshfs-win-connect.ini"
$Server = $Config.ServerSFTP
$DefaultLetter = $Config.NetworkDrive

$GetServer = Read-Host -Prompt "Enter the remote server [$Server]"
If ($GetServer.ToLower() -ne '') {
	$Server = $GetServer
}

$User = $Env:UserName
$GetUser = Read-Host -Prompt "Enter the remote user login [$User]"
If ($GetUser.ToLower() -ne '') {
	$User = $GetUser
}

Do {
	$Letter = $DefaultLetter
	$GetLetter = Read-Host -Prompt "Enter the local letter to use [$Letter]"
	If ($GetLetter.ToLower() -ne '') {
		$Letter = $GetLetter
	}

	$Next = "Yes"
	If ((Get-PSDrive).Name -match "^${Letter}$") {
		$Next = "No"
		Write-Output "Drive lettre ${Letter} is already in use"
		$Continue = Read-Host -Prompt "Do you want to try another driver letter [Y/n]"
		If ($Continue.ToLower() -eq 'n') {
			Write-Output "`nPress any key to finish..."
			[Console]::ReadKey($true) | Out-Null
			Exit
		}
	}
} Until ($Next -eq "Yes")

Write-Output "Associate the drive ${Letter} to the server \\sshfs\${User}@${Server}"
Write-Output "You will have to give again your login (small bug) and then your password`n"
net use ${Letter}: "\\sshfs\${User}@${Server}"

Write-Output "`nPress any key to finish..."
[Console]::ReadKey($true) | Out-Null
Exit
