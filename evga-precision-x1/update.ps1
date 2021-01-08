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

Function Get-EvgaRedirectUrl ($path) {
    $base    = 'https://www.evga.com'
    $headers = @{
      "method"="GET"
        "authority"="www.evga.com"
        "scheme"="https"
        #"path"="/EVGA/GeneralDownloading.aspx?file=EVGA_Precision_X1_1.1.4.zip"
        "path"=$path
        "sec-ch-ua"="`"Google Chrome`";v=`"87`", `" Not;A Brand`";v=`"99`", `"Chromium`";v=`"87`""
        "sec-ch-ua-mobile"="?0"
        "upgrade-insecure-requests"="1"
        "user-agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"
        "accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
        "sec-fetch-site"="same-origin"
        "sec-fetch-mode"="navigate"
        "sec-fetch-user"="?1"
        "sec-fetch-dest"="document"
        "referer"="https://www.evga.com/precisionx1/"
        "accept-encoding"="gzip, deflate, br"
        "accept-language"="nl-NL,nl;q=0.9,en-US;q=0.8,en;q=0.7"
        #"cookie"="BNIS_STCookie=ey2cbmF0CTQKocnZD5Aehiku6Y+mJPLOCMQpMXJGhNzsZw9SQUFk6t+SPaMN897OfxnwPI62tjyzM33vt1Gp0koFSOjru8l4; SameSite=Lax; __auc=30240c52174fdb5fa831f2e91eb; _ga=GA1.2.1655695726.1601984396; _fbp=fb.1.1601984396001.250165877; __asc=30240c52174fdb5fa831f2e91eb; BNES___asc=JL6qvqRDqR63dE32QE/Dj4Aip9YpUfdHvzM7YODYY89bgUzSukzi/cF9Cx/VX6O9ZwncTdWgHp7Xya3MQ42t1Cq7bzekHvvv; __auc=30240c52174fdb5fa831f2e91eb; _ga=GA1.2.1655695726.1601984396; _gid=GA1.2.696146749.1601984396; _gat=1; BNES__gat=0/m0QawwEDbLYnBG8pGDQnUh0y8jvLe309Em+MZiWvfP9bxzbPms+A==; _fbp=fb.1.1601984396001.250165877; BNES__gid=kezcHRIMcgfu4bC2q3oSaSi1Ij1uk1YjVzSgo8RbsL9YwOx30jjPCT/6NxM2J8+wVQBoXs9tdzSidA+Jdne6kWkAiU/c53VY; BNES___auc=VPPhdPJcaq8e4qcWlNw1/fDPivPakTxRCsu6j0tTfYtxLQv8oi3FFAkqRa66rZnB5m8kyUIhrRgxvt/dTMJTHIZ40boRsdRz; BNES__ga=pqLJUK/Xic0E1rwofjWc0AVD7RCPC0Dfr4ve2KWay8CdqkhnSzfpzO0PMd6cY2DUjd5p5p1A42jElu9A3XpvMra/zbxKs99A; BNES__fbp=uuz0fsD/AD7o6xmGtL/keUK6XkKci3ywYSIfPYGCqe3UxJbCNzu45NqwA16wUFY9NBr8SopT14K8Pr2xNspjJPjbHuxxoWTY; _abck=7E6FAECBBD4D6888C52791C1797FAEA8~0~YAAQ9LL3SIRspVl1AQAAeL0biARC71DyVA/MlfETJC5ZirRVgMw41KLZepqaxUIysn6z068UJFEyruGyojegb1fW/qNEvztMMw1HAudBm5//1OJ0eQrD63W/0BxofgbDK4vNKiqJJbA/PFVwMg8l0PE+B0z9JUPZagUALSyunJnBPWC0mummlmqBwXCaRIfFzYJXoW0cqoyAl/3P/YiHm849AQyIs5ZJ0LR+tDtfYtxxI5/4Z47C2YgB47iQfz2p6/tI+IhtnLrHpU8JnITYRLTfWs41M9t9jxjQEadAL1e9s2BCX4EHd8vcqYSOIzbjZtIY3C0=~-1~-1~-1; .ASPXANONYMOUS=QuIUU2gD1wEkAAAAN2NlYTIzMTUtMDk1ZS00MWQ2LWFlZmYtMWQyZWI0ZTNlMWFjp-b_xZDYmG-PaDEcXVr4iNdLarQ1; CookieConfirm=1607715528453; ASPSESSIONIDCETSRACR=DNIGKACDHGIGGOCJLDKDLGIH; bm_sz=7352B4650B913086FE022D11EC6B5900~YAAQF3ARAhE+Fs52AQAAJs324Ao3pdtQOmhKQq2vuHX3kFzXB7fp84cpLcEF1LQTI3aeWG630HnoNl8CdHYLXYJV/THjj5g3Kp2fMQM7heQ9bO7ztT9R2jiZxlaXX3cdzSzLMGICqYmaKSwOGpwaiQ1uhqHCJfBaDuzsxDUIVLkZozOPQAaKzmXmph0j8A==; __asc=30240c52174fdb5fa831f2e91eb; ak_bmsc=B4E44B0E01A690C60F2A2F544268817F02117017E83A0000070EF85F37E71041~plRajDGvtc2JE9vB7LQUDa1Sk5dGkjF4sURb9ZJp6GblqkrdnQIOjD87tGyRdFSPg1u8dvpuMI12Ff4VLstw4PwBOM6qFioxlaSZPee0Qbm57v97skfQUhs9sdSW6rBI7aWDF3Jg9sWmFogRYqcRVfbbVcifyoVNRzVBsSa4QNaqdgWRwwXjDeXL1VjLAOtb1lDgYmMSWDpN4pnaJ0Hg+xTLDUusWc8jn+CSjTjBzaPhT9r67VcQXNYpCTmnGKIVek; ASP.NET_SessionId=51wnxrcox0pd2tf2hgmuqejb; bm_sv=003BA0CCA5EC45B6F94A958FF23DFAEE~tMKyjO3ZEIhuV0QzyF1PV3NWxfaDHUL7I8XaeOaIcapvguG3RRPvExlyQRJrdbl5VsKPp4Q68DcM6hqxGeESF0eYLDcl7P6E1BUsmvjqVlzP+57Gxz1TpZi2qIcbUM0qblRCXMfggkFrNtW2fSIkyw=="
      }
    $uri = $base + $path
    $r = Invoke-WebRequest -UseBasicParsing -Headers $headers -Method Get -Uri $Uri -MaximumRedirection 0 -ea 0
    $r.headers.location
  }
  

function global:au_GetLatest {


    $headers = @{
        "method"="GET"
        "scheme"="https"
        "upgrade-insecure-requests"="1"
        "accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
        "referer"="https://www.evga.com/"
        "accept-encoding"="gzip, deflate, br"
    }
    
    $page = Invoke-WebRequest -Uri ($base + $releases) -UseBasicParsing -Headers $headers
    $link = $page.links | Where-Object OuterHTML -Like '*download-button*standalone*' | 
    Select-Object -First 1 -ExpandProperty href

    $path = $link -replace '&survey.*',''
    $url = Get-EvgaRedirectUrl -path $path
  
    if ($url -notmatch 'https://storage.cdn.evga.com.*zip') {
       throw 'Failed to get EVGA redirect URL'
    }
    $version = [regex]::replace($link, '.*?([0-9.]+)\.zip.*', '$1')
    $packageName = 'evga-precision-x1'


    return @{
        URL         = $url
        Version     = $version
        PackageName = $packageName
        Checksum    = Get-RemoteChecksum $url -Headers $headers
        docsUrl     = ($base + $releases)
        FileName    = ($packageName + '.zip' )
    }
}

update -ChecksumFor none -NoCheckUrl -NoCheckChocoVersion