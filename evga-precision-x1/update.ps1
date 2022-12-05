Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = "https://www.evga.com/precisionx1/PX1Update.txt?v="

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
    $versionCapture = $page.Content | sls 'ProductVersion\s+=\s+([0-9\.]+)' -AllMatches
    $fileCapture = $page.Content | sls 'FileURL\s+=\s+(\S+)' -AllMatches
    $producPageCapture = $page.Content | sls 'ProductURL\s+=\s+(\S+)' -AllMatches

    Write-Verbose "Found version $version at ${$dllink.href}"

    $content = Invoke-RestMethod $fileCapture.Matches.Groups[1].value -Headers $headers 
    $memstream = [System.IO.MemoryStream]::new($content.ToCharArray())
    $thisFileHash = Get-FileHash -InputStream $memstream -Algorithm SHA256

    return @{
        URL         = $fileCapture.Matches.Groups[1].value
        Version     = $versionCapture.Matches.Groups[1].value
        PackageName = 'evga-precision-x1'
        Checksum    = $thisFileHash.Hash
        docsUrl     = $producPageCapture.Matches.Groups[1].value
        FileName    = ($fileCapture.Matches.Groups[1].value -split '=')[-1]
    }
}

update -verbose -ChecksumFor none -NoCheckUrl