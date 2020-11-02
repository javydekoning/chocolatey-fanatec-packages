$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$filePath = "$toolsDir\fanatec_driver.msi"
$packageName = 'fanatec-driver'
$url = 'https://fanatec.com/media/unknown/fe/df/ab/Fanatec_32_driver_346.msi'
$url64 = 'https://fanatec.com/media/unknown/a8/ff/14/Fanatec_64_driver_346.msi'

$downloadArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileFullPath   = $filePath
  url            = $url
  url64bit       = $url64
  checksum       = '157acfc38c9e5306cdd58ccbdbd9350773de1a3adbf88403c3dbb5e58aacce38'
  checksumType   = 'sha256'
  checksum64     = '119F39DCA732AD2925FC3D124ECF0D07EC42BDD25350A08B52308090861690CD'
  checksumType64 = 'sha256'
  options        = @{
    Headers = @{             
      Accept = '*/*'
    }
  }
}

Get-ChocolateyWebFile @downloadArgs

$computerName = $Env:COMPUTERNAME
$installerPath = $downloadArgs.fileFullPath
$store = New-Object Security.Cryptography.X509Certificates.X509Store("$computerName\TrustedPublisher", 'LocalMachine')

$store.Open('ReadWrite, OpenExistingOnly')
$store.Add((Get-AuthenticodeSignature $installerPath).SignerCertificate)
$store.Close()

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

$tmpfile = [system.io.path]::GetTempFileName()
@"
-----BEGIN CERTIFICATE-----
MIIFETCCA/mgAwIBAgIQKGOPh5gDgut6tYlwv9eO5TANBgkqhkiG9w0BAQUFADCB
tDELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQL
ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2Ug
YXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykxMDEuMCwGA1UEAxMl
VmVyaVNpZ24gQ2xhc3MgMyBDb2RlIFNpZ25pbmcgMjAxMCBDQTAeFw0xODA3MTYw
MDAwMDBaFw0xOTA5MTYyMzU5NTlaMHMxCzAJBgNVBAYTAlBIMRUwEwYDVQQIDAxN
ZXRybyBNYW5pbGExEzARBgNVBAcMClBhc2lnIENpdHkxGzAZBgNVBAoMEkRhdHJv
bmljc29mdCwgSW5jLjEbMBkGA1UEAwwSRGF0cm9uaWNzb2Z0LCBJbmMuMIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2zHpYvtLF4FAkzhCHGUYc+MuzdHX
niiyi9H6heSaoo7aQV3NHPWNoCoVZv+VarRmiCIX3Ej3+do7fbvFz8ZUNrFc4TnJ
vlBPO/IbzEDunv/dFK31AbIOSFdZr8o3aVEGdTCaFOEuMNRg/oUnDfo9XgwfJ1q0
yop1YRRSmdyHUMaRwDDDNMNBLFR/Qe2zdbDvIp5LBSNbm1pG92Qx/QmpYmLyYjlH
XI7jZbsqacqIkFKpw3LBpAKom7sRshUOzLS+A/KTLw9Zb53AGZo7TRGK/MM7PLuf
VMVyPBI/jgeQcF5OPDBkcB4WozX4tzZC0TRhkRbrRY0wha4FLmNC78NNtQIDAQAB
o4IBXTCCAVkwCQYDVR0TBAIwADAOBgNVHQ8BAf8EBAMCB4AwKwYDVR0fBCQwIjAg
oB6gHIYaaHR0cDovL3NmLnN5bWNiLmNvbS9zZi5jcmwwYQYDVR0gBFowWDBWBgZn
gQwBBAEwTDAjBggrBgEFBQcCARYXaHR0cHM6Ly9kLnN5bWNiLmNvbS9jcHMwJQYI
KwYBBQUHAgIwGQwXaHR0cHM6Ly9kLnN5bWNiLmNvbS9ycGEwEwYDVR0lBAwwCgYI
KwYBBQUHAwMwVwYIKwYBBQUHAQEESzBJMB8GCCsGAQUFBzABhhNodHRwOi8vc2Yu
c3ltY2QuY29tMCYGCCsGAQUFBzAChhpodHRwOi8vc2Yuc3ltY2IuY29tL3NmLmNy
dDAfBgNVHSMEGDAWgBTPmanqeyb0S8mOj9fwBSbv49KnnTAdBgNVHQ4EFgQUYSAR
h5aKVOg59HW2vtRPzqBf+LwwDQYJKoZIhvcNAQEFBQADggEBANydOw6TAo29TeQk
p5Dll7j5pLDygukhR653PUhuTX9vA9KGyOaUdsxrUDxymghbcBQavfAOA3zX7tZL
2vxWYICCLDADdnpQzWfMgvFtst5ytWF44Bjnxy7QEc1YPubgKVygmLuDr6KjJMq8
RFqzjAokt4zBTRihaWaIXxQdgXbrCjtgMQtR6k95ncRfLDSDJoQc/j1+gKNu2zjb
sBURO4d+K7ilsojRKZ/gl8qmqRvS4vbu6Gfj3JetetCGT9obeWIp88MtqGr74/Wk
FwaOs6kS3SiH83E9RYabzLoHp/yQNTOPI9TIA1IOumzkjnFCq+RHV6ZRITMwZAUo
j32yPWk=
-----END CERTIFICATE-----
"@ | Out-File $tmpfile -Encoding utf8 
Import-Certificate -filepath $tmpfile -CertStoreLocation 'Cert:\localmachine\TrustedPublisher\'

$packageArgs = @{
  packageName         = $packageName
  fileType            = 'msi'
  url                 = $downloadArgs.fileFullPath
  silentArgs          = "/qn /norestart"
  validExitCodes      = @(0, 3010, 1641)
  UseOriginalLocation = $true
}

Install-ChocolateyPackage  @packageArgs

Remove-Item $filePath 