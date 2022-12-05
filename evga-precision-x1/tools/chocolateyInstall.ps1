$ErrorActionPreference = 'Stop'
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;

$toolsDir    = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$packageName = 'evga-precision-x1'

$url      = 'https://storage.cdn.evga.com/software/EVGA_Precision_X1_1.3.7.0.exe'
$FileName = 'EVGA_Precision_X1_1.3.7.0.exe'
$checksum = '16156C9DD17483F44B87A5081ADE71EAE927285C076A3947D0B9517DACF95393'

$headers = @{
  "Upgrade-Insecure-Requests" = "1"
  "User-Agent"                = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36"
  "Accept"                    = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
  "Sec-Fetch-Site"            = "none"
  "Sec-Fetch-Mode"            = "navigate"
  "Sec-Fetch-Dest"            = "document"
  "Accept-Encoding"           = "gzip, deflate, br"
  "Accept-Language"           = "en-US,en;q=0.9"
}

$FullFilePath = Join-Path $toolsDir $FileName
Invoke-RestMethod $url -Headers $headers -OutFile $FullFilePath -ea Stop -verbose

$packageArgs = @{
  packageName         = $packageName
  File64              = $FullFilePath
  fileType            = 'exe'
  silentArgs          = "/S"
  validExitCodes      = @(0, 3010, 1641)
}

Install-ChocolateyPackage  @packageArgs -options $options