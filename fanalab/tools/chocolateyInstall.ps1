$ErrorActionPreference = 'Stop'

$packageName = 'fanalab'
$url = 'https://forum.fanatec.com/uploads/341/119AAT4UN898.zip'
$checksum = '168140c7279cf8967ae161c0956653ce8ec52980be210ed2610881b072764832'
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
