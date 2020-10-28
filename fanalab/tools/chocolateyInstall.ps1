$ErrorActionPreference = 'Stop'

$packageName = 'fanalab'
$url = 'https://forum.fanatec.com/uploads/832/9QPM5VG48L3N.zip'
$checksum = '053C486B63A0A1F02AD564167DBC32CAE88BBAA41F0BF1F104D505BC599CA546'
$filePath = "$toolsDir\fanalab.zip"
$fileType = 'zip'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
$embedded_path = Get-Item "$toolsDir\*.$fileType"
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$downloadArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileFullPath = $filePath
  url          = $url
  checksum     = $checksum
  #checksumType = 'sha256'
  options      = @{
    Headers = @{             
      Accept = '*/*'
    }
  }
}

Get-ChocolateyWebFile @downloadArgs


# $packageArgs = @{
#   packageName    = $packageName
#   fileType       = $fileType
#   file           = $embedded_path
#   silentArgs     = '/VERYSILENT /TASKS=' + ($tasks -join ',')
#   validExitCodes = @(0)
#   softwareName   = $packageName
# }
# Install-ChocolateyInstallPackage @packageArgs
# rm $embedded_path -ea 0

# $packageName = $packageArgs.packageName
# $installLocation = Get-AppInstallLocation $packageName
# if (!$installLocation) { Write-Warning "Can't find $packageName install location"; return }
# Write-Host "$packageName installed to '$installLocation'"

# Register-Application "$installLocation\$packageName.exe"
# Write-Host "$packageName registered as $packageName"

# start "$installLocation\$packageName.exe"
