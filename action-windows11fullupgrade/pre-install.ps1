
Write-Output "Begin Pre-Install"

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

if ($(Get-HardwareReadiness).IsCapable -eq $true) {
	Write-Output 'All requirements ready for upgrade to Windows 11 !'
}
Else {
	Write-Output 'not ready'
	$data = Get-HardwareReadiness
	$Reason = $data.Reason
	Write-Output "Reason : $Reason"
	if (($Reason -like '*TPM not compatible*') -Or ($Reason -like '*Processor not compatible*')){
		If (!(Test-Path 'HKLM:\SYSTEM\Setup\MoSetup')) {
		New-Item -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Force | Out-Null
		}
	Write-Output 'add AllowUpgradesWithUnsupportedTPMOrCPU in registry'
	Set-ItemProperty -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Name 'AllowUpgradesWithUnsupportedTPMOrCPU' -Type DWord -Value  1
	}
}



# Bypass TPM
#$CheckTPM_Version = (Get-Tpm).ManufacturerVersionFull20
#If (($CheckTPM_Version -like '*not supported*') -Or ($CheckTPM_Version -like '*non pris*')) {
#	Write-Output 'Warning: TPM not 2.0 - Registry bypass before install'
#	If (!(Test-Path 'HKLM:\SYSTEM\Setup\MoSetup')) {
#		New-Item -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Force | Out-Null
#	}
#	Set-ItemProperty -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Name 'AllowUpgradesWithUnsupportedTPMOrCPU' -Type DWord -Value  1
#} Else {
#	Write-Output "TPM >= 2.0 - Normal install Continue"
#}
