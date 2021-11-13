$ErrorActionPreference = 'Stop'

$packageName = 'fanalab'
$url = 'https://forum.fanatec.com/uploads/676/0YXMB6ZD1VVC.zip'
$checksum = 'b796e2489386d229c62b9ea57963d74866f05d854eaf075b6b4eed438ef1ea6d'
$filePath = "$toolsDir\fanalab.zip"

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$downloadArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileFullPath = $filePath
  url          = $url
  checksum     = $checksum
  checksumType = 'sha256'
  options      = @{
    Headers = @{             
      Accept = '*/*'
    }
  }
}

Get-ChocolateyWebFile @downloadArgs
Get-ChocolateyUnzip -FileFullPath $filePath -Destination $toolsDir

$fileTypeUnzipped = 'msi'
$embedded_path = Get-ChildItem -Recurse $toolsDir *.$fileTypeUnzipped | Select-Object -ExpandProperty FullName
$packageArgs = @{
  packageName    = $packageName
  fileType       = $fileTypeUnzipped
  file           = $embedded_path
  silentArgs     = '/qn'
  validExitCodes = @(0)
  softwareName   = $packageName
}
Install-ChocolateyInstallPackage @packageArgs
Remove-Item $embedded_path -ea 0


$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation) { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"
