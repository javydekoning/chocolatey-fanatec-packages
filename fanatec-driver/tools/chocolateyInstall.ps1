$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = 'fanatec-driver'
  fileType      = 'msi'
  url           = 'https://fanatec.com/media/unknown/fe/df/ab/Fanatec_32_driver_346.msi'
  url64bit      = 'https://fanatec.com/media/unknown/a8/ff/14/Fanatec_64_driver_346.msi'
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'fanatec-driver'
  checksum      = '157acfc38c9e5306cdd58ccbdbd9350773de1a3adbf88403c3dbb5e58aacce38'
  checksumType  = 'sha256'
  checksum64    = '119F39DCA732AD2925FC3D124ECF0D07EC42BDD25350A08B52308090861690CD'
  checksumType64= 'sha256'
}

Install-ChocolateyPackage @packageArgs
