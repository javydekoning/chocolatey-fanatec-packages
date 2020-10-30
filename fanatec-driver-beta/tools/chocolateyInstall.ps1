$ErrorActionPreference = 'Stop'

$FileName = 'UB5ML9470EP4.zip'

$UnzipLocation = Join-Path "$env:TMP" ([io.path]::GetFileNameWithoutExtension( $FileName ))

$packageArgs = @{
  packageName   = 'fanatec-driver-beta'
  url           = 'https://forum.fanatec.com/uploads/599/UB5ML9470EP4.zip'
  checksum      = 'ce7b79a4f76ed748bff0641bca7db6eb74667a9770154f7087fbd9f5f3167f51'
  checksumType  = 'sha256'
  UnzipLocation = $UnzipLocation
}

Write-Verbose "Unzip to $($packageArgs.UnzipLocation)"

Install-ChocolateyZipPackage @packageArgs

$FilePath32 = Get-ChildItem $packageArgs.UnzipLocation -Recurse *32*driver*.msi | sort name | Select-Object -Last 1
$FilePath64 = Get-ChildItem $packageArgs.UnzipLocation -Recurse *64*driver*.msi | sort name | Select-Object -Last 1

Write-Verbose "Using $($FilePath64.FullName)"

$tmpfile = [system.io.path]::GetTempFileName()
@"
-----BEGIN CERTIFICATE-----
MIIFYzCCBEugAwIBAgIQNBbeX5vDM9RCHtPVWEJ1rDANBgkqhkiG9w0BAQsFADCB
kTELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8w
HQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMUIwQAYDVQQDEzlTeW1hbnRl
YyBDbGFzcyAzIEV4dGVuZGVkIFZhbGlkYXRpb24gQ29kZSBTaWduaW5nIENBIC0g
RzIwHhcNMTYxMDEzMDAwMDAwWhcNMTkxMDEzMjM1OTU5WjCB5DETMBEGCysGAQQB
gjc8AgEDEwJERTEXMBUGCysGAQQBgjc8AgECDAZCYXllcm4xGTAXBgsrBgEEAYI3
PAIBAQwITGFuZHNodXQxHTAbBgNVBA8TFFByaXZhdGUgT3JnYW5pemF0aW9uMREw
DwYDVQQFEwhIUkIgNTQ4NzELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjER
MA8GA1UEBwwITGFuZHNodXQxETAPBgNVBAoMCEVuZG9yIEFHMRAwDgYDVQQLDAdG
YW5hdGVjMREwDwYDVQQDDAhFbmRvciBBRzCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAMXxcUJ5NWjYytJyzL9hnAwiMR+mD27dQJ/zKQQ6e5k9L37uT9Jh
C74hem3UomnYbvlnDB81YlSk51zroqNhawdg27ZKoqbbwYRPS9haf83BJqycTnyz
qH8JSnlhM9dfqac2dStn46GO3TXzlXxMk3DOblMb8he8uwWZilpSdIf/rdVJEcF8
auLsSQauUsK92Gk0bdIfX3IZw46dKFYrFMuah/bDG4L5Z1w8tr51xAmgFW25yJfj
bk11NYlgeSo+f3WEXLZYdThnouXgMRLXjc49CorGqQCnIvRvcw2dKf6i1212PuTt
TfUJ+XlrqnAXx7F8EMgSmACvrv9rkonjWT8CAwEAAaOCAWAwggFcMAkGA1UdEwQC
MAAwDgYDVR0PAQH/BAQDAgeAMCsGA1UdHwQkMCIwIKAeoByGGmh0dHA6Ly9zdy5z
eW1jYi5jb20vc3cuY3JsMGAGA1UdIARZMFcwVQYFZ4EMAQMwTDAjBggrBgEFBQcC
ARYXaHR0cHM6Ly9kLnN5bWNiLmNvbS9jcHMwJQYIKwYBBQUHAgIwGQwXaHR0cHM6
Ly9kLnN5bWNiLmNvbS9ycGEwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwMwHwYDVR0j
BBgwFoAUFmbeSjTjUKcRhgOxbKnGrM1ZbpswHQYDVR0OBBYEFNOKbVzFpqsVihZ/
v61mGQAiRnelMFgGCCsGAQUFBwEBBEwwSjAfBggrBgEFBQcwAYYTaHR0cDovL3N3
LnN5bWNkLmNvbTAnBggrBgEFBQcwAoYbaHR0cDovL3N3MS5zeW1jYi5jb20vc3cu
Y3J0MA0GCSqGSIb3DQEBCwUAA4IBAQAB3K+ajkmSr6v6+6uwVS2tu0yxn/G/i3zL
0vXZWO+zJXoGyWGHubsgotIijBcj/ZrXPF6Z+tH6TqDZxN/HkqxB2hvI3Fwg5HpB
gUoJty66iVZBJXS9AcxwSxQ0pkRi1NGOnj4EPy4xlHyzhAPGKRrwwxoS/MtyBUEB
UXW6gAe542zhM9r2C9C+DGnNSTIzq2Y1KITYEN5Vap4D44UtWBpOOArAQ65S5eT2
pOFnS5v2cOfRBCYHnkYk71/oKYsFwiaL90rS5FpdVFtOg3qbodH9VII4GlKKhBtU
6UKDMoPXuLBKOfF0DJVpjziYTZLA6y9zahqP93N+ZZ+TLfzItao9
-----END CERTIFICATE-----
"@ | Out-File $tmpfile -Encoding utf8 
Import-Certificate -filepath $tmpfile -CertStoreLocation 'Cert:\localmachine\TrustedPublisher\'

$packageArgs = @{
  packageName    = 'fanatec-driver-beta'
  FileType       = 'msi'
  SilentArgs     = '/qn /norestart'
  File           = $FilePath32.FullName
  File64         = $FilePath64.FullName
  validExitCodes = @(0, 3010, 1641)
}
  
Install-ChocolateyInstallPackage @packageArgs

Remove-Item $UnzipLocation -Recurse -Force