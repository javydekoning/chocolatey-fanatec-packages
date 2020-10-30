Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://fanatec.com/eu-en/racing-wheels-wheel-bases/wheel-bases/podium-wheel-base-dd1#downloads'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]packageName\s+=\s+)(.*)" = "`$1'$($Latest.PackageName)'"
            "(?i)(^\s*[$]url\s+=\s+)(.*)"         = "`$1'$($Latest.URL)'"
            "(?i)(^\s*[$]url64\s+=\s+)(.*)"       = "`$1'$($Latest.URL64)'"
            "(?i)(^\s+checksum\s+=\s+)(.*)"       = "`$1'$($Latest.Checksum)'"
            "(?i)(^\s+checksum64\s+=\s+)(.*)"     = "`$1'$($Latest.Checksum64)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<docsUrl\>).*?(\</docsUrl\>)" = "`${1}$($Latest.DocsUrl)`$2"
            "(\<version\>).*?(\</version\>)" = "`${1}$($Latest.Version)`$2"
        }

        ".\legal\VERIFICATION.txt"      = @{
            "(?i)(\s+url:).*"                = "`${1} $($Latest.URL)"
            "(?i)(\s+url64bit:).*"           = "`${1} $($Latest.URL64)"
            "(?i)(checksum:).*"              = "`${1} $($Latest.Checksum)"
            "(?i)(checksum64:).*"            = "`${1} $($Latest.Checksum64)"
            "(?i)(32.+Get-RemoteChecksum).*" = "`${1} $($Latest.URL)"
            "(?i)(64.+Get-RemoteChecksum).*" = "`${1} $($Latest.URL64)"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }
function global:au_AfterUpdate { Set-DescriptionFromReadme -SkipFirst 2 }

function global:au_GetLatest {
    $html = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $url = ( $html.links | ? href -like '*32*driver*msi' | 
             sort title -desc |  #Select latest version
             select -first 1
           ).href           

    $url64 = ( $html.links | ? href -like '*64*driver*msi' | 
               sort title -desc |  #Select latest version
               select -first 1
             ).href


    $version = [regex]::replace($url64, '.*driver_(\d+).msi.*', '$1') 

    return @{
        URL         = $url
        URL64       = $url64
        # Prefixing 1.0. because Fanatec is not adhering to 
        # https://docs.microsoft.com/en-us/nuget/concepts/package-versioning
        Version     = '1.0.' + $version 
        PackageName = 'fanatec-driver'
        FileType    = $url64.split('.')[-1]
        Checksum    = Get-RemoteChecksum $url
        Checksum64  = Get-RemoteChecksum $url64
        DocsUrl     = $releases
    }
}

update -ChecksumFor none
