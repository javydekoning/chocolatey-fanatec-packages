$ErrorActionPreference = 'Stop'

$packageName = 'fanalab'
$url = 'https://forum.fanatec.com/uploads/670/DZ1R9446Y4QR.zip'
$checksum = '820ede74edd30e23bda905de7fa33697c26c1163866eb619b30e3fc1cb3119ca'
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
