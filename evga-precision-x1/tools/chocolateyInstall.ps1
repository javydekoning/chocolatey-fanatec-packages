$ErrorActionPreference = 'Stop'

$toolsDir    = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$packageName = 'evga-precision-x1'

$url      = 'https://www.evga.com/EVGA/GeneralDownloading.aspx?file=EVGA_Precision_X1_1.3.7.0.exe'
$FileName = 'EVGA_Precision_X1_1.3.7.0.exe'
$checksum = '16156C9DD17483F44B87A5081ADE71EAE927285C076A3947D0B9517DACF95393'

$packageArgs = @{
  packageName         = $packageName
  url64               = $url
  fileType            = 'exe'
  file                = $ExeFilePath.FullName
  silentArgs          = "/S"
  validExitCodes      = @(0, 3010, 1641)
}

Install-ChocolateyPackage  @packageArgs