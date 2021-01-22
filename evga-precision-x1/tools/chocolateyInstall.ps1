$ErrorActionPreference = 'Stop'

$toolsDir    = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$packageName = 'evga-precision-x1'

$url = 'https://fichiers.touslesdrivers.com/67280/EVGA_Precision_X1_1.1.6.0.zip'
$FileName = 'evga-precision-x1.zip'
$checksum = '87441f09c26c8c0506e12ac0e2dd3fb3d3b694d1cf82e7b0d526fc11d9c62aa7'

$UnzipLocation = Join-Path "$env:TMP" ([io.path]::GetFileNameWithoutExtension( $FileName ))

$downloadArgs = @{
  packageName   = $packageName
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
  UnzipLocation = $UnzipLocation
  options       = @{
    Headers = @{
      "Upgrade-Insecure-Requests" = "1"
      "User-Agent"                = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36"
      "Accept"                    = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
      "Sec-Fetch-Site"            = "none"
      "Sec-Fetch-Mode"            = "navigate"
      "Sec-Fetch-Dest"            = "document"
      "Accept-Encoding"           = "gzip, deflate, br"
      "Accept-Language"           = "en-US,en;q=0.9"
    }
  }
}


Write-Host "UNPACK TO $UnzipLocation"
Install-ChocolateyZipPackage @downloadArgs 

$ExeFilePath = Get-ChildItem $UnzipLocation -Recurse *evga*.exe | Where-Object fullname -Match $packageName | sort name | Select-Object -Last 1

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
