$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$filePath = "$toolsDir\fanatec_driver.msi"
$packageName = 'evga-precision-x1'
$url = 'https://fanatec.com/media/unknown/fe/df/ab/Fanatec_32_driver_346.msi'
$FileName = 'UB5ML9470EP4.zip'
$UnzipLocation = Join-Path "$env:TMP" ([io.path]::GetFileNameWithoutExtension( $FileName ))

$downloadArgs = @{
  packageName   = $packageName
  url           = $url
  checksum      = 'ce7b79a4f76ed748bff0641bca7db6eb74667a9770154f7087fbd9f5f3167f51'
  checksumType  = 'sha256'
  UnzipLocation = $UnzipLocation
  options       = @{
    Headers = @{             
      Accept = '*/*'
    }
  }
}

Write-Verbose "Unzip to $($packageArgs.UnzipLocation)"

Install-ChocolateyZipPackage @downloadArgs

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