# Script: cache.ps1

# Function ClearBrowserCaches
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
				Start-Sleep -Seconds 2
            } elseif ($cachePath -and (Test-Path -Path $cachePath)) {
                Remove-Item -Path $cachePath -Recurse -Force
                Write-Host "$($browser.Name) Cache Cleared."
				Start-Sleep -Seconds 2
            } else {
                Write-Host "$($browser.Name) Cache Missing..."
				Write-Host "...$($browser.Name) Cleaning Bypassed."
				Start-Sleep -Seconds 2
            }
        } else {
            Write-Host "$($browser.Name) Not Installed."
        }
    }
}

# Function ClearDnsClientCache
# Function Manage Cache
function ClearDnsClientCache {
    Write-Host "Clearing DNS Cache..."
    Clear-DnsClientCache
    Write-Host "...DNS Cache Cleared."
	Start-Sleep -Seconds 2
}

