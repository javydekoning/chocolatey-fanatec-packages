$ErrorActionPreference = 'Stop'

#Download and unzip
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$packageName = 'fanatec-driver'
$url = 'https://fanatec.com/media/archive/5b/89/52/2020-11-19-Fanatec_driver_381.zip'
$checksum = '0c486e52c4151ab2de0376459d4d0fe1d8dd1ef2fae79a70669ccde91339739e'
$filePath = "$toolsDir\$packageName.zip"

$downloadArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileFullPath = $filePath
  url          = $url
  checksum     = 'ade1a9ac2a6b71b5df5d7d8423eeda913d3310cb6e50b31bbc7e3c5a917508ed'
  checksumType = 'sha256'
  options      = @{
    Headers = @{             
      Accept = '*/*'
    }
  }
}

Get-ChocolateyWebFile @downloadArgs
Get-ChocolateyUnzip -FileFullPath $filePath -Destination $toolsDir

$ahkFile = Join-Path $toolsDir "driver.ahk"
Start-Process -FilePath 'AutoHotKey' -ArgumentList $ahkFile

#Install MSI
$FilePath32 = Get-ChildItem $toolsDir -Recurse *32*driver*.msi | sort name | Select-Object -Last 1
$FilePath64 = Get-ChildItem $toolsDir -Recurse *64*driver*.msi | sort name | Select-Object -Last 1

Write-Verbose "Found ${$FilePath64.FullName}"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  FileType       = 'msi'
  SilentArgs     = '/qn /norestart /l*v c:\fanatec-driver_msi_install.log'
  File           = $FilePath32.FullName
  File64         = $FilePath64.FullName
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage  @packageArgs