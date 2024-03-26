
Write-Output "Begin Pre-Install"

Write-Output "Info: import certificate Adafruit"
Import-Certificate -FilePath 'Adafruit.cer' -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

Write-Output "Info: import certificate Arduino"
Import-Certificate -FilePath 'Arduino.cer'  -CertStoreLocation Cert:\LocalMachine\TrustedPublisher
