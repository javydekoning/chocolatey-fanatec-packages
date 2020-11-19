$ErrorActionPreference = 'Stop'

$toolsDir      = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$packageName   = 'evga-precision-x1'

$url           = 'https://www.evga.com/EVGA/GeneralDownloading.aspx?file=EVGA_Precision_X1_1.1.1.zip&survey=11.1.1'
$FileName      = 'evga-precision-x1.zip'
$checksum      = '52873ff701917aa101da0861306f39460742d014216a64c13fdc37f6e565dbc2'

$UnzipLocation = Join-Path "$env:TMP" ([io.path]::GetFileNameWithoutExtension( $FileName ))

$downloadArgs = @{
  packageName   = $packageName
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
  UnzipLocation = $UnzipLocation
  options       = @{
    Headers = @{             
      Accept = '*/*'
    }
  }
}

write-host "UNPACK TO $UnzipLocation"
Install-ChocolateyZipPackage @downloadArgs 

$ExeFilePath = Get-ChildItem $UnzipLocation -Recurse *evga*.exe | ? fullname -match $packageName | sort name | Select-Object -Last 1

$packageArgs = @{
  packageName         = $packageName
  fileType            = 'exe'
  file                = $ExeFilePath.FullName
  silentArgs          = "/S"
  validExitCodes      = @(0, 3010, 1641)
  UseOriginalLocation = $true
}

Install-ChocolateyPackage  @packageArgs

Remove-Item $UnzipLocation -Recurse -Force