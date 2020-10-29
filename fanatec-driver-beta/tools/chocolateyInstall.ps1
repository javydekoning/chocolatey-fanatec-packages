$ErrorActionPreference = 'Stop'

$FileName = 'UB5ML9470EP4.zip'

$UnzipLocation = [io.path]::GetFileNameWithoutExtension( (join-path "$env:TMP" $FileName) )

$packageArgs = @{
  packageName            = 'fanatec-driver-beta'
  url                    = 'https://forum.fanatec.com/uploads/599/UB5ML9470EP4.zip'
  checksum               = 'ce7b79a4f76ed748bff0641bca7db6eb74667a9770154f7087fbd9f5f3167f51'
  checksumType           = 'sha256'
  UnzipLocation          = $UnzipLocation
}

Install-ChocolateyZipPackage @packageArgs

$FilePath = gci $packageArgs.UnzipLocation -Recurse *64*driver*.msi

$packageArgs = @{
  packageName            = 'fanatec-driver-beta'
  FileType               = 'msi'
  SilentArgs             = '/qn /norestart'
  File                   = $FilePath.FullName
  validExitCodes         = @(0, 3010, 1641)
}
  
Install-ChocolateyInstallPackage @packageArgs
