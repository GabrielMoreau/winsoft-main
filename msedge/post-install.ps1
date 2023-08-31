
# Post-install for add extension
# https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#extensioninstallforcelist

# Force install Ublock Origin on Edge
# https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist")) {
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "1" -Type REG_SZ -Value "odfafepnkmbhccpbejgmiehpchacaeak"
}
