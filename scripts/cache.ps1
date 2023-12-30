# Script: cache.ps1

function ClearBrowserCaches {
    $browsers = @(
        @{ Name = "Firefox"; RegPath = "HKLM:\SOFTWARE\Mozilla\Mozilla Firefox"; CachePath = "C:\Users\$env:USERNAME\AppData\Local\Mozilla\Firefox\Profiles\*\cache2\entries" },
        @{ Name = "Internet Explorer"; RegPath = "HKLM:\SOFTWARE\Microsoft\Internet Explorer"; CachePath = "RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8; $null" },
        @{ Name = "Microsoft Edge"; RegPath = "HKLM:\SOFTWARE\Microsoft\Edge"; CachePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache" }
        # Additional browsers can be added here
    )

    foreach ($browser in $browsers) {
        if (Test-Path $browser.RegPath) {
            Write-Host "$($browser.Name) Detected, Trying Cache."
            $cachePath = $browser.CachePath
            if ($browser.Name -eq "Internet Explorer") {
                # Special case for Internet Explorer
                RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
                Write-Host "...Internet Explorer Cache Cleared."
            } elseif ($cachePath -and (Test-Path -Path $cachePath)) {
                Remove-Item -Path $cachePath -Recurse -Force
                Write-Host "$($browser.Name) Cache Cleared."
            } else {
                Write-Host "$($browser.Name) Cache Missing..."
				Write-Host "...$($browser.Name) Cleaning Bypassed."
            }
        } else {
            Write-Host "$($browser.Name) Not Installed."
        }
    }
}


# Function Manage Cache
function ClearDnsClientCache {
    Write-Host "Managing Cache"
    Clear-DnsClientCache
    Write-Host "DNS cache cleared"
}

