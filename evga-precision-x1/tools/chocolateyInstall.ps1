$ErrorActionPreference = 'Stop'

$toolsDir      = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$packageName   = 'evga-precision-x1'

$url           = 'https://www.evga.com/EVGA/GeneralDownloading.aspx?file=EVGA_Precision_X1_1.1.2.0.zip&survey=11.1.2.0'
$FileName      = 'evga-precision-x1.zip'
$checksum      = '4a10a96509680ef73061d30fd4a2ac2f9aa249491575af3eaa80d8162fc72938'

$UnzipLocation = Join-Path "$env:TMP" ([io.path]::GetFileNameWithoutExtension( $FileName ))

$downloadArgs = @{
  packageName   = $packageName
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
  UnzipLocation = $UnzipLocation
  options       = @{
    Headers = @{             
      'Upgrade-Insecure-Requests' = '1'
      'User-Agent'                = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36'
      'Accept'                    = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'
      'Referer'                   = 'https://www.evga.com/'
      'Accept-Encoding'           = 'gzip, deflate, br'
      'Accept-Language'           = 'nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7'
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
