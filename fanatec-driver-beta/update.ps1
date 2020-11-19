Import-Module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://forum.fanatec.com/discussion/601/latest-beta-drivers-bookmark-this-thread-to-be-notified-of-new-uploads'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s+packageName\s+=\s+)(.*)" = "`$1'$($Latest.PackageName)'"
            "(?i)(^\s+url\s+=\s+)(.*)"         = "`$1'$($Latest.URL)'"
            "(?i)(^\s+checksum\s+=\s+)(.*)"    = "`$1'$($Latest.Checksum)'"
            "(?i)(^\s*[$]FileName\s+=\s+)(.*)" = "`$1'$($Latest.FileName)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<docsUrl\>).*?(\</docsUrl\>)" = "`${1}$($Latest.DocsUrl)`$2"
            "(\<version\>).*?(\</version\>)" = "`${1}$($Latest.Version)`$2"
        }

        ".\legal\VERIFICATION.txt"      = @{
            "(?i)(\s+url:).*"               = "`${1} $($Latest.URL)"
            "(?i)(\s+checksum:).*"          = "`${1} $($Latest.Checksum)"
            "(?i)(\s+Get-RemoteChecksum).*" = "`${1} $($Latest.URL)"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }
function global:au_AfterUpdate { Set-DescriptionFromReadme -SkipFirst 2 }

function global:au_GetLatest {
    if (! (Get-Module Powerhtml -ListAvailable)) {
        Install-Module powerhtml -Force -SkipPublisherCheck
    }
    Import-Module Powerhtml -Force

    $page = Invoke-WebRequest $releases -UseBasicParsing 
    $latest = ($page.Links | Where-Object { $_.href -match '.*driver.*\d{3}.*' } | Select-Object -Last 1).href
    $htmlDom = (Invoke-WebRequest $latest -UseBasicParsing).RawContent | ConvertFrom-Html
    $Post = $htmlDom.SelectSingleNode('//div[@class="Message userContent"]').OuterHtml
    $DlLink = ($Post | ConvertFrom-Html).SelectNodes('//a') | Where-Object InnerText -Like '*driver*zip*'
    $url = $DlLink.GetAttributeValue('href', '')

    $version = [regex]::replace($DlLink.innertext, '(?i).*driver_(\d+).+?(alpha|beta|rc)?.*', '$1-$2').trim()

    return @{
        URL         = $url
        # Prefixing 1.0. because Fanatec is not adhering to 
        # https://docs.microsoft.com/en-us/nuget/concepts/package-versioning
        Version     = '1.0.' + $version.trim('-').ToLower()
        PackageName = 'fanatec-driver-beta'
        FileType    = $url.split('.')[-1]
        Checksum    = Get-RemoteChecksum $url
        DocsUrl     = $releases
        FileName    = $url.split('/')[-1]
    }
}

update -ChecksumFor none
