
# Create PostInstall Task
If (Test-Path -LiteralPath "$Env:ProgramData\OCS Inventory NG\DelayedInstall\post-install.bat") {
	$PostInstallUser    = "NT AUTHORITY\SYSTEM"
	$PostInstallTask    = 'OCSInventory-ReInstall'
	$PostInstallTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(45)
	$PostInstallTrigger.EndBoundary = (Get-Date).AddSeconds(120).ToString('s')
	$PostInstallSetting = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter 00:00:01 -ExecutionTimeLimit (New-TimeSpan -Minutes 240)
	$PostInstallAction = New-ScheduledTaskAction -Execute "post-install.bat" `
		-WorkingDirectory "$Env:ProgramData\OCS Inventory NG\DelayedInstall"
	Register-ScheduledTask -Force -TaskName $PostInstallTask -Trigger $PostInstallTrigger -User $PostInstallUser -Action $PostInstallAction `
		-Description "OCSInventory-ReInstall" -Settings $PostInstallSetting
	$PostInstallObject = Get-ScheduledTask $PostInstallTask
	$PostInstallObject.Author = "CNRS LEGI"
	$PostInstallObject | Set-ScheduledTask
}
