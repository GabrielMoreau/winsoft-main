
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Output ("Begin Pre-Install [$TimeStamp]`n" + "=" * 39 + "`n")

########################################################################
# Put your specific code here

# Beta script
# Apply bypass for old TPM

# Force script to speak english
[cultureinfo]::CurrentUICulture='en-US'

# SecureBoot Query
If (!(Confirm-SecureBootUEFI)) {
	Write-Error 'Error: SecureBoot is OFF!'
	Exit 12
}

# TPM Query
If (!(Get-Tpm).TpmReady) {
	Write-Output 'Get-TPM informations'
	Get-Tpm
	Write-Error 'Error: TPM not ready!'
	Exit 13
}

Import-Module .\HardwareReadiness

If ($(Get-HardwareReadiness).IsCapable -eq $True) {
	Write-Output 'All requirements ready for upgrade to Windows 11 !'
}
Else {
	Write-Output 'not ready'
	$Data = Get-HardwareReadiness
	$Reason = $Data.Reason
	Write-Output "Reason : $Reason"
	If (($Reason -like '*TPM not compatible*') -Or ($Reason -like '*Processor not compatible*')) {
		If (!(Test-Path 'HKLM:\SYSTEM\Setup\MoSetup')) {
			New-Item -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Force | Out-Null
		}
	Write-Output 'add AllowUpgradesWithUnsupportedTPMOrCPU in registry'
	Set-ItemProperty -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Name 'AllowUpgradesWithUnsupportedTPMOrCPU' -Type DWord -Value  1
	}
}
