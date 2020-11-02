Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://www.evga.com/precisionx1/'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
            "(?i)(^\s*[$]fileType\s*=\s*)('.*')"    = "`$1'$($Latest.FileType)'"
            "(?i)(^\s*[$]url\s*=\s*)('.*')"         = "`$1'$($Latest.URL)'"
            "(?i)(^\s*[$]checksum\s*=\s*)('.*')"    = "`$1'$($Latest.Checksum)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<docsUrl\>).*?(\</docsUrl\>)" = "`${1}$($Latest.docsUrl)`$2"
            "(\<version\>).*?(\</version\>)" = "`${1}$($Latest.Version)`$2"
        }

        ".\legal\VERIFICATION.txt"      = @{
            "(?i)(\s+url:).*"            = "`${1} $($Latest.URL)"
            "(?i)(checksum:).*"          = "`${1} $($Latest.Checksum)"
            "(?i)(Get-RemoteChecksum).*" = "`${1} $($Latest.URL)"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }
function global:au_AfterUpdate { Set-DescriptionFromReadme -SkipFirst 2 }

function global:au_GetLatest {
    $headers = @{
        'User-Agent'                = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv=8'2.0) Gecko/20100101 Firefox/82.0"
        'Accept'                    = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
        'Accept-Language'           = 'en-US,en;q=0.5'
        'Connection'                = 'keep-alive' 
        'Upgrade-Insecure-Requests' = '1' 
        'Cache-Control'             = 'max-age=0'
    }
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing -Headers $headers
    $link = $page.links | Where-Object OuterHTML -Like '*download-button*standalone*' | 
    Select-Object -First 1 -ExpandProperty href
    $version = [regex]::replace($link, '.*?([0-9.]+)\.zip.*', '$1')

    return @{
        URL         = $link
        Version     = $version
        PackageName = 'evga-precision-x1'
        #Checksum    = Get-RemoteChecksum $url
        docsUrl     = $releases
    }
}

update -ChecksumFor none
