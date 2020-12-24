Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$base     = 'https://www.evga.com'
$releases = '/precisionx1/'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
            "(?i)(^\s*[$]FileName\s*=\s*)('.*')"    = "`$1'$($Latest.FileName)'"
            "(?i)(^\s*[$]url\s*=\s*)('.*')"         = "`$1'$($Latest.URL)'"
            "(?i)(^\s*[$]checksum\s*=\s*)('.*')"    = "`$1'$($Latest.Checksum)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<docsUrl\>).*?(\</docsUrl\>)" = "`${1}$($Latest.docsUrl)`$2"
            "(\<version\>).*?(\</version\>)" = "`${1}$($Latest.Version)`$2"
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
        'Connection'                = 'keep-alive' #Doesn't work in GH actions due to proxy nature. Needed for local invoke.
        'Upgrade-Insecure-Requests' = '1' 
        'Cache-Control'             = 'max-age=0'
    }
    
    $page = Invoke-WebRequest -Uri ($base + $releases) -UseBasicParsing -Headers $headers
    $link = $page.links | Where-Object OuterHTML -Like '*download-button*standalone*' | 
    Select-Object -First 1 -ExpandProperty href
    $version = [regex]::replace($link, '.*?([0-9.]+)\.zip.*', '$1')
    $packageName = 'evga-precision-x1'
    $url = $base + $link

    return @{
        URL         = $url
        Version     = $version
        PackageName = $packageName
        Checksum    = Get-RemoteChecksum $url -Headers $headers
        docsUrl     = ($base + $releases)
        FileName    = ($packageName + '.zip' )
    }
}

update -ChecksumFor none -NoCheckUrl