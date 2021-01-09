Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://fanatec.com/eu-en/racing-wheels-wheel-bases/wheel-bases/podium-wheel-base-dd1#downloads'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]packageName\s+=\s+)(.*)" = "`$1'$($Latest.PackageName)'"
            "(?i)(^\s*[$]url\s+=\s+)(.*)"         = "`$1'$($Latest.URL)'"
            "(?i)(^\s+checksum\s+=\s+)(.*)"       = "`$1'$($Latest.Checksum)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<docsUrl\>).*?(\</docsUrl\>)" = "`${1}$($Latest.DocsUrl)`$2"
            "(\<version\>).*?(\</version\>)" = "`${1}$($Latest.Version)`$2"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }
function global:au_AfterUpdate { Set-DescriptionFromReadme -SkipFirst 2 }

function global:au_GetLatest {
    $html = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $url = ( $html.links | ? href -match '.*driver.\d+.*' | 
             sort title -desc |  #Select latest version
             select -first 1
           ).href           

    $version = [regex]::replace($url, '.*driver.(\d+).*', '$1') 

    return @{
        URL         = $url
        # Prefixing 1.0. because Fanatec is not adhering to 
        # https://docs.microsoft.com/en-us/nuget/concepts/package-versioning
        Version     = '1.0.' + $version 
        PackageName = 'fanatec-driver'
        FileType    = $url.split('.')[-1]
        Checksum    = Get-RemoteChecksum $url
        DocsUrl     = $releases
    }
}

update -ChecksumFor none
