# Test
# Apply bypass for old TPM

# SecureBoot
If (!(Confirm-SecureBootUEFI)) {
  Write-Error "SecureBoot is OFF!"
  exit 2
}

# TPM
If (!(Get-Tpm).TpmReady) {
  Write-Output "Get-TPM informations"
  Get-Tpm
  Write-Error "TPM not ready!"
  exit 3
}

# Bypass
$checkTPMVersion = (Get-Tpm).ManufacturerVersionFull20
if ($checkTPMVersion -like '*not supported*') or $checkTPMVersion -like '*non pris*') {
  Write-out "TPM not 2.0 - Registry bypass"
  New-Item -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Force | Out-Null
  New-ItemProperty -Name 'AllowUpgradesWithUnsupportedTPMOrCPU' -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Value  1 -PropertyType DWord
  }
else {
  Write-out "TPM >= 2.0"
  }
