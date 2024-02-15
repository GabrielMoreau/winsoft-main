
Write-Output "Begin Post-Install"

# Create PostInstall Task
If (Test-Path -LiteralPath "${Env:ProgramData}\OCS Inventory NG\DelayedInstall\install-outofservice.bat") {
	$PostInstallUser    = "NT AUTHORITY\SYSTEM"
	$PostInstallTask    = 'OCSInventory-Install-OutOfService'
	$PostInstallTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(60)
	$PostInstallTrigger.EndBoundary = (Get-Date).AddSeconds(180).ToString('s')
	$PostInstallSetting = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter 00:00:01 -ExecutionTimeLimit (New-TimeSpan -Minutes 300)
	$PostInstallAction = New-ScheduledTaskAction `
		-Execute "${Env:ProgramData}\OCS Inventory NG\DelayedInstall\install-outofservice.bat" `
		-WorkingDirectory "${Env:ProgramData}\OCS Inventory NG\DelayedInstall"
	Register-ScheduledTask -Force -TaskName $PostInstallTask `
		-Trigger $PostInstallTrigger `
		-User $PostInstallUser `
		-Action $PostInstallAction `
		-Description "OCSInventory-ReInstall" `
		-Settings $PostInstallSetting
	$PostInstallObject = Get-ScheduledTask $PostInstallTask
	$PostInstallObject.Author = "CNRS LEGI"
	$PostInstallObject | Set-ScheduledTask
}
