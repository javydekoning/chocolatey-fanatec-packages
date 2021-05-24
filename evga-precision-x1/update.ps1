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
    $userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)"
    $headers = @{
        "User-Agent" = $userAgent
    }
    
    # Get Latest version
    $request = [System.Net.WebRequest]::Create("https://www.evga.com/precisionx1/PX1Update.txt?v=")
    $request.Method = "Get"
    $response = $request.GetResponse()
    $reqStream = $response.GetResponseStream()
    $readStream = New-Object System.IO.StreamReader $reqStream
    $data = $readStream.ReadToEnd()

    $fileUrl = [regex]::match($data, 'FileURL\s+=\s(\S+)').Groups[1].Value
    $version = [regex]::match($data, 'ProductVersion\s+=\s(\d\.\d\.\d\.\d)').Groups[1].Value

    # Get FileHash
    # $reqFile = [System.Net.HttpWebRequest]::Create($fileUrl)
    # $reqFile.Headers.Add($userAgent)
    # $resFile = $reqFile.GetResponse()
    # $req1 = [System.Net.HttpWebRequest]::Create($resFile.ResponseUri)
    # $res1 = $req1.GetResponse()
    # $reader = [System.IO.StreamReader]::new($res1.GetResponseStream())
    # $reader.ReadToEnd() | Out-File test.exe 
    # Get-FileHash test.exe -Algo SHA256 

    return @{
        URL         = $fileUrl
        Version     = $version
        PackageName = $packageName
        Checksum    = Get-RemoteChecksum $fileUrl -Headers $headers
        docsUrl     = 'https://www.evga.com/precisionx1/'
        FileName    = ($packageName + '.exe' )
    }
}

update -verbose -ChecksumFor none