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

Function Get-EvgaRedirectUrl ($path) {
    $base = 'https://www.evga.com'
    $headers = @{
        "method"                    = "GET"
        "authority"                 = "www.evga.com"
        "scheme"                    = "https"
        #"path"="/EVGA/GeneralDownloading.aspx?file=EVGA_Precision_X1_1.1.4.zip"
        "path"                      = $path
        "sec-ch-ua"                 = "`"Google Chrome`";v=`"87`", `" Not;A Brand`";v=`"99`", `"Chromium`";v=`"87`""
        "sec-ch-ua-mobile"          = "?0"
        "upgrade-insecure-requests" = "1"
        "user-agent"                = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"
        "accept"                    = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
        "sec-fetch-site"            = "same-origin"
        "sec-fetch-mode"            = "navigate"
        "sec-fetch-user"            = "?1"
        "sec-fetch-dest"            = "document"
        "referer"                   = "https://www.evga.com/precisionx1/"
        "accept-encoding"           = "gzip, deflate, br"
        "accept-language"           = "nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7"
    }
    $uri = $base + $path
    $r = Invoke-WebRequest -UseBasicParsing -Headers $headers -Method Get -Uri $Uri -MaximumRedirection 0 -ea 0
    $r.headers.location
}
  

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

    return @{
        URL         = $dllink.href
        Version     = $version
        PackageName = $packageName
        Checksum    = Get-RemoteChecksum $url -Headers $headers
        docsUrl     = ($base + $releases)
        FileName    = ($packageName + '.zip' )
    }
}

update -ChecksumFor none -NoCheckUrl -NoCheckChocoVersion