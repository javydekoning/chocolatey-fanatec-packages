$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$filePath = "$toolsDir\fanatec_driver.msi"

$downloadArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileFullPath = $filePath
  url           = 'https://fanatec.com/media/unknown/fe/df/ab/Fanatec_32_driver_346.msi'
  url64bit      = 'https://fanatec.com/media/unknown/a8/ff/14/Fanatec_64_driver_346.msi'
  checksum      = '157acfc38c9e5306cdd58ccbdbd9350773de1a3adbf88403c3dbb5e58aacce38'
  checksumType  = 'sha256'
  checksum64    = '119F39DCA732AD2925FC3D124ECF0D07EC42BDD25350A08B52308090861690CD'
  checksumType64= 'sha256'
  options      = @{
      Headers = @{             
          Accept  = '*/*'
          Referer = 'https://www.amd.com/en/support/chipsets/amd-socket-am4/a320'
      }
  }
}

Get-ChocolateyWebFile @downloadArgs

$computerName = $Env:COMPUTERNAME
$installerPath = $downloadArgs.fileFullPath
$store = New-Object Security.Cryptography.X509Certificates.X509Store(
  "$computerName\TrustedPublisher", 'LocalMachine')
$store.Open('ReadWrite, OpenExistingOnly')
$store.Add((Get-AuthenticodeSignature $installerPath).SignerCertificate)
$store.Close()

Install-ChocolateyPackage -url $downloadArgs.fileFullPath -silentArgs "/qn /norestart" -validExitCodes @(0, 3010, 1641) -filetype 'msi' -UseOriginalLocation