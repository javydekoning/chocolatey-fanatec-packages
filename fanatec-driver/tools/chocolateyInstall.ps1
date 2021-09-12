$ErrorActionPreference = 'Stop'

#Download and unzip
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$packageName = 'fanatec-driver'
$url = 'https://fanatec.com/media/archive/b5/9a/8a/2021-08-25-Fanatec_driver_411.zip'
$checksum = '0c486e52c4151ab2de0376459d4d0fe1d8dd1ef2fae79a70669ccde91339739e'
$filePath = "$toolsDir\$packageName.zip"

$downloadArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileFullPath = $filePath
  url          = $url
  checksum     = '30b3be77bbe61c1eca40df23d5690e872b005abe55f04ae787b6c98c729dd477'
  checksumType = 'sha256'
  options      = @{
    Headers = @{             
      Accept = '*/*'
    }
  }
}

Get-ChocolateyWebFile @downloadArgs
Get-ChocolateyUnzip -FileFullPath $filePath -Destination $toolsDir

#Install certificates
$DatronicsoftCert = @"
-----BEGIN CERTIFICATE-----
MIIFDTCCA/WgAwIBAgIQC6ugKJImPkz/9khsCnmETTANBgkqhkiG9w0BAQUFADBz
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMTIwMAYDVQQDEylEaWdpQ2VydCBIaWdoIEFzc3VyYW5j
ZSBDb2RlIFNpZ25pbmcgQ0EtMTAeFw0xOTA5MjUwMDAwMDBaFw0yMDA5MjgxMjAw
MDBaMFUxCzAJBgNVBAYTAlBIMQ4wDAYDVQQHEwVQYXNpZzEaMBgGA1UEChMRRGF0
cm9uaWNzb2Z0IEluYy4xGjAYBgNVBAMTEURhdHJvbmljc29mdCBJbmMuMIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwqW0s0RYH62ro3JErtzfUgRqjXC1
SwFmuKprh2hhtqHpqic8yxeQUP2dEOckstMjhvnSnCso5hQH3ZeaCq7uir8S6TfX
jhEdMZnT5nsT1O4QgHnLvNEBLckgMN51dQRJdpMNSgNA2Okkz2TC42KXqJX4CFa/
wmfrFHsOr0yqmC3NL+4Yvm7jxkJDPRboVqUQKpi/pUsqBvlfS5VzOp4WDwEfX0Fp
316GXCHaUiPbAsAIVm5QMpnBirGr6lqIO2MeNChFoo02OZfAVg1Z35ie31C1HzCY
UoaoBaqNg9/59dMXQxdqzvyctOYOGIgm9mFozLiU6cS3xHWGYzxkTE5/gQIDAQAB
o4IBuTCCAbUwHwYDVR0jBBgwFoAUl0gD6xUIa7myWCPMlC7xxmXSZI4wHQYDVR0O
BBYEFIaLjgcjJbC1CxY/TFHHeV7Gxu2ZMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUE
DDAKBggrBgEFBQcDAzBpBgNVHR8EYjBgMC6gLKAqhihodHRwOi8vY3JsMy5kaWdp
Y2VydC5jb20vaGEtY3MtMjAxMWEuY3JsMC6gLKAqhihodHRwOi8vY3JsNC5kaWdp
Y2VydC5jb20vaGEtY3MtMjAxMWEuY3JsMEwGA1UdIARFMEMwNwYJYIZIAYb9bAMB
MCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCAYG
Z4EMAQQBMIGGBggrBgEFBQcBAQR6MHgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3Nw
LmRpZ2ljZXJ0LmNvbTBQBggrBgEFBQcwAoZEaHR0cDovL2NhY2VydHMuZGlnaWNl
cnQuY29tL0RpZ2lDZXJ0SGlnaEFzc3VyYW5jZUNvZGVTaWduaW5nQ0EtMS5jcnQw
DAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOCAQEAtj5l2kMMpMJ2CZIzzF89
sE/qV3drFJ6jp+YI+8eXXl+pMOrfdsADntUpnXXU649lh7TkECjnfYCIKf5HI90v
euS1H87fjadWR3amDMXBrALFg3jCiaGIztrD8/lmnzy37ZO6VE2zD0wfH+2CQj81
+0FOYBHsE+/e5ds+2McVWWEyPthW+vNzcJHndwIBWubE1A4NNIN9PMllImXVVd57
7XVnKzVQ+ImrzaGZIgzjsuYrh/g15XUBkm5jWKS6gjNVGjhlZZKHczcz+uRYHZmF
0Arzx/bzzagK61Amdg3Zh7jP9FTfpP8xNES2U7CiO7Jv6bMKw144Y82IkRVr8GBp
YA==
-----END CERTIFICATE-----
"@

$DatronicsoftCert2 = @"
-----BEGIN CERTIFICATE-----
MIIFCTCCA/GgAwIBAgIQBWmMSDvXIfpo6c5Xp0K2gTANBgkqhkiG9w0BAQUFADBv
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMS4wLAYDVQQDEyVEaWdpQ2VydCBBc3N1cmVkIElEIENv
ZGUgU2lnbmluZyBDQS0xMB4XDTIwMDkwMjAwMDAwMFoXDTIzMTEwMzEyMDAwMFow
VTELMAkGA1UEBhMCUEgxDjAMBgNVBAcTBVBhc2lnMRowGAYDVQQKExFEYXRyb25p
Y3NvZnQgSW5jLjEaMBgGA1UEAxMRRGF0cm9uaWNzb2Z0IEluYy4wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpsuvIpVKQDgEHvpaU7WD8vZIzzWLmzyUV
f9FVjK7F6Y7qrIvoC45mToJagPF5FQ6ejj9Cb6q+KK7RNviMKzhAJjE3ljgiY/mH
QnIEvEYQVzqRSJaNA7SmCVhvhxNtf23J7VxJ4/4fuY1b7HAGeLZDEJCIjQ+4rMyG
nHa7P+2vGonOBJ7XG/MO8YECgVS9f4uSHhRJUlv1ze50EFYA1cHoVawFIPgrcfvY
ssjQM0b/A2qIMwJ1hMPAWBoxWgvbSirBnPGIdsl+oPJA9HX1JSnlMP7DB9BLMNis
vS1oxsMnyk80Ejy48ZQeC8PklZwJGvfZ3Pj54wjDsBql0bFs0Wi9AgMBAAGjggG5
MIIBtTAfBgNVHSMEGDAWgBR7aM4pqsAXvkl64eU/1qf3RY81MjAdBgNVHQ4EFgQU
sHZEulMut12hY6FxiAkz+eJI+wIwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoG
CCsGAQUFBwMDMG0GA1UdHwRmMGQwMKAuoCyGKmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0
LmNvbS9hc3N1cmVkLWNzLWcxLmNybDAwoC6gLIYqaHR0cDovL2NybDQuZGlnaWNl
cnQuY29tL2Fzc3VyZWQtY3MtZzEuY3JsMEwGA1UdIARFMEMwNwYJYIZIAYb9bAMB
MCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCAYG
Z4EMAQQBMIGCBggrBgEFBQcBAQR2MHQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3Nw
LmRpZ2ljZXJ0LmNvbTBMBggrBgEFBQcwAoZAaHR0cDovL2NhY2VydHMuZGlnaWNl
cnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEQ29kZVNpZ25pbmdDQS0xLmNydDAMBgNV
HRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4IBAQBbZI62dNG4NzIdbPRituXMmreK
HD/JpvjbtYg5GEWSxYZ7qDIDSwhAD3NqkXO+O3qJmg8GsPW81/2tsZLyWutOECqE
n4V/I/DV0B8UR2wyFDJsHRm9rVFMJ9kU/rx+tFfE86Ofgx1ahHoXZpcy4tzptMFR
AUEwkBLDd/ogzZnj4gEbT89XhnKS+crx9A59CCLpLpT8Qn78nhBO1fqku6hJm+Mm
e647vpV8/5JhaXDOyDzX6f6sW1VMXcnIxBrDh6O4kVod9Sc7MeWzKAD5RnYyQCbn
gcrkJf05axUKepU5f9fIYkLJpWE6qSZolmLHUa0un1eJ5azfL2oAxMYk7RfY
-----END CERTIFICATE-----
"@

$EndorAgCert = @"
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
"@

# Windows 7 doesn't have import-certificate, hence using wrapper func
if (!(Test-Path Function:\Import-Certificate)) {
  function Import-Certificate([string]$FilePath, [string]$CertStoreLocation) {
    $certSplits = $CertStoreLocation -replace '^cert\:\\' -split '\\'
    if (!($certSplits.Length -eq 2)) { throw "Unexpected certificate storage location" }

    $certutil = Get-Command "certutil" | Select-Object -ExpandProperty Path

    if (!$certutil) { throw "Path to certutil was not found" }

    $arguments = @(
      '-addstore'
      $certSplits[1]
      "$(Resolve-Path $FilePath)"
    )

    Start-ChocolateyProcessAsAdmin -ExeToRun $certutil -Statements $arguments
  }
}

$DatronicsoftCert, $DatronicsoftCert2, $EndorAgCert | ForEach-Object {
  $tmpFile = [system.io.path]::GetTempFileName()
  $_ | Out-File $tmpFile -Encoding utf8
  Import-Certificate -filepath $tmpFile -CertStoreLocation 'Cert:\localmachine\TrustedPublisher'
}

# AHK won't interact with Windows Security window for some reason.
# Hence installing the certs manually to prevent popup
# $ahkFile = Join-Path $toolsDir "driver.ahk"
# Start-Process -FilePath 'AutoHotKey' -ArgumentList $ahkFile

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
