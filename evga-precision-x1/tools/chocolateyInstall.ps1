$ErrorActionPreference = 'Stop'

$toolsDir      = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$packageName   = 'evga-precision-x1'

$url           = 'https://storage.cdn.evga.com/software/EVGA_Precision_X1_1.1.4.zip'
$FileName      = 'evga-precision-x1.zip'
$checksum      = 'b6c4c0b067b02299a3b13b0fffe73d6c41a9d08efb68d7d11c10b891a4ba28e9'

$UnzipLocation = Join-Path "$env:TMP" ([io.path]::GetFileNameWithoutExtension( $FileName ))

$downloadArgs = @{
  packageName   = $packageName
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
  UnzipLocation = $UnzipLocation
  options       = @{
    Headers = @{
        "method"="GET"
        "authority"="storage.cdn.evga.com"
        "scheme"="https"
        "path"="/software/EVGA_Precision_X1_1.1.4.zip"
        "upgrade-insecure-requests"="1"
        "accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
        "referer"="https://www.evga.com/"
        "accept-encoding"="gzip, deflate, br"
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
