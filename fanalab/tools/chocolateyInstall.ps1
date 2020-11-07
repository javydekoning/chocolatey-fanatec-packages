$ErrorActionPreference = 'Stop'

$packageName = 'fanalab'
$url = 'https://forum.fanatec.com/uploads/824/4U2V3GC7G8QU.zip'
$checksum = '3f045c5e11077afa520332673a18cfbed0f6610b138342a83ee1c2fdb6222d24'
$filePath = "$toolsDir\fanalab.zip"
$fileType = 'zip'

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
$embedded_path = Get-Item "$toolsDir\*.$fileTypeUnzipped"
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

# Register-Application "$installLocation\$packageName.exe"
# Write-Host "$packageName registered as $packageName"

# start "$installLocation\$packageName.exe"
