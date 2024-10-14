
Write-Output "Begin Pre-Install"

# See https://adamtheautomator.com/pending-reboot-registry/

Function Test-RegistryKey {
	[OutputType('bool')]
	Param (
		[Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Key
	)

	If (Get-Item -Path $Key -ErrorAction Ignore) {
		Return $True
	}
	Return $False
}

Function Test-RegistryValue {
	[OutputType('bool')]
	Param (
		[Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Key,
		[Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Value
	)

	If (Get-ItemProperty -Path $Key -Name $Value -ErrorAction Ignore) {
		Return $True
	}
	Return $False
}

Function Test-RegistryValueNotNull {
	[OutputType('bool')]
	Param (
		[Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Key,
		[Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Value
	)

	If (($RegVal = Get-ItemProperty -Path $Key -Name $Value -ErrorAction Ignore) -and $RegVal.($Value)) {
		Return $True
	}
	Return $False
}

# Added "Test-Path" to each test that did not leverage a custom Function from above since
# an exception is thrown when Get-ItemProperty or Get-ChildItem are passed a nonexistant key path
$PendingTest= @(
	{ Test-RegistryKey -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending' }
	{ Test-RegistryKey -Key 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootInProgress' }
	{ Test-RegistryKey -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired' }
	{ Test-RegistryKey -Key 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackagesPending' }
	{ Test-RegistryKey -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\PostRebootReporting' }
	# { Test-RegistryValueNotNull -Key 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Value 'PendingFileRenameOperations' }
	# { Test-RegistryValueNotNull -Key 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Value 'PendingFileRenameOperations2' }
	{ 
		# Added test to check first if key exists, using "ErrorAction ignore" will incorrectly return $True
		'HKLM:\SOFTWARE\Microsoft\Updates' | Where-Object { Test-path $_ -PathType Container } | ForEach-Object {            
			(Get-ItemProperty -Path $_ -Name 'UpdateExeVolatile' | Select-Object -ExpandProperty UpdateExeVolatile) -ne 0 
		}
	}
	# { Test-RegistryValue -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce' -Value 'DVDRebootSignal' }
	{ Test-RegistryKey -Key 'HKLM:\SOFTWARE\Microsoft\ServerManager\CurrentRebootAttemps' }
	#{ Test-RegistryValue -Key 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon' -Value 'JoinDomain' }
	#{ Test-RegistryValue -Key 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon' -Value 'AvoidSpnSet' }
	#{
	#	# Added test to check first if keys exists, if not each group will return $Null
	#	# May need to evaluate what it means if one or both of these keys do not exist
	#	( 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName' | Where-Object { Test-path $_ } | %{ (Get-ItemProperty -Path $_ ).ComputerName } ) -ne 
	#	( 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName' | Where-Object { Test-Path $_ } | %{ (Get-ItemProperty -Path $_ ).ComputerName } )
	#}
	#{
	#	# Added test to check first if key exists
	#	'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\Pending' | Where-Object { 
	#		(Test-Path $_) -and (Get-ChildItem -Path $_) } | ForEach-Object { $True }
	#}
)

$Count = 0
foreach ($Test in $PendingTest) {
	$Count++
	Write-Output "Running scriptblock ${Count}: [$($Test.ToString())]"
	If (& $Test) {
		Write-Output "Warning: Need to reboot machine according to ${Count} test"
		Exit $Count
		Break
	}
}

Write-Output "No pending Reboot"
Exit 0
