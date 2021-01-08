Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://www.touslesdrivers.com/index.php?v_page=12&v_code=922'

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
        "Upgrade-Insecure-Requests" = "1"
        "User-Agent"                = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36"
        "Accept"                    = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
        "Sec-Fetch-Site"            = "none"
        "Sec-Fetch-Mode"            = "navigate"
        "Sec-Fetch-Dest"            = "document"
        "Accept-Encoding"           = "gzip, deflate, br"
        "Accept-Language"           = "en-US,en;q=0.9"
    }
    
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing -Headers $headers
    $link = $page.links | Where-Object OuterHTML -Like '*Precision X1*' |
    Select-Object -First 1 -ExpandProperty href
    $vcode = ($link -split '=')[-1]

    $mirrors = 'https://www.touslesdrivers.com/php/constructeurs/telechargement.php?v_code={0}' -f $vcode
    $links = Invoke-WebRequest -Uri $mirrors -UseBasicParsing -Headers $headers
    $dllink = $links.links | Where-Object href -Match 'fichiers.touslesdrivers.com'

    $version = [regex]::replace($dllink.href, '.*?([0-9.]+)\.zip.*', '$1')
    $packageName = 'evga-precision-x1'
    Write-Verbose "Found version $version at ${$dllink.href}"

    return @{
        URL         = $dllink.href
        Version     = $version
        PackageName = $packageName
        Checksum    = Get-RemoteChecksum $dllink.href -Headers $headers
        docsUrl     = 'https://www.evga.com/precisionx1/'
        FileName    = ($packageName + '.zip' )
    }
}

update -verbose -ChecksumFor none