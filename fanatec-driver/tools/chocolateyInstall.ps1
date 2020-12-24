$ErrorActionPreference = 'Stop'

#Download and unzip
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$packageName = 'fanatec-driver'
$url = 'https://fanatec.com/media/archive/5b/89/52/2020-11-19-Fanatec_driver_381.zip'
$checksum = '0c486e52c4151ab2de0376459d4d0fe1d8dd1ef2fae79a70669ccde91339739e'
$filePath = "$toolsDir\$packageName.zip"

$downloadArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileFullPath = $filePath
  url          = $url
  checksum     = 'ade1a9ac2a6b71b5df5d7d8423eeda913d3310cb6e50b31bbc7e3c5a917508ed'
  checksumType = 'sha256'
  options      = @{
    Headers = @{             
      Accept = '*/*'
    }
  }
}

Get-ChocolateyWebFile @downloadArgs
Get-ChocolateyUnzip -FileFullPath $filePath -Destination $toolsDir

#Install Driver Code-Signing Certificate
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

#Install MSI
$FilePath32 = Get-ChildItem $toolsDir -Recurse *32*driver*.msi | sort name | Select-Object -Last 1
$FilePath64 = Get-ChildItem $toolsDir -Recurse *64*driver*.msi | sort name | Select-Object -Last 1

Write-Verbose "Found ${$FilePath64.FullName}"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  FileType       = 'msi'
  SilentArgs     = '/qn /norestart /l*v c:\fanatec-driver_msi_install.log'
  File           = $FilePath32.FullName
  File64         = $FilePath64.FullName
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage  @packageArgs