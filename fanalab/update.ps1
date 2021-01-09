Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://forum.fanatec.com/categories/fanalab'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
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
    $category_page = Invoke-WebRequest -Uri $releases -UseBasicParsing |
    Select-Object -ExpandProperty links | 
    Where-Object { $_.outerHTML -match '.*FanaLab \d\.\d+.*' } | 
    Select-Object -First 1

    $dl_page = Invoke-WebRequest $category_page.href -UseBasicParsing

    $re = "https://forum.fanatec.com/uploads/.*\.zip"
    $url = $dl_page.links | Where-Object href -Match $re | Select-Object -First 1 -expand href
    $version = [regex]::replace($category_page.outerHTML, '.*FanaLab ([0-9.]+).*', '$1') 

    return @{
        URL         = $url
        Version     = $version
        PackageName = 'fanalab'
        FileType    = $url.split('.')[-1]
        Checksum    = Get-RemoteChecksum $url
        docsUrl     = $category_page.href
    }
}

update -ChecksumFor none