# Script: cache.ps1

function ClearBrowserCaches {
    $browsers = @(
        @{ Name = "Firefox"; RegPath = "HKLM:\SOFTWARE\Mozilla\Mozilla Firefox"; CachePath = { "C:\Users\$env:USERNAME\AppData\Local\Mozilla\Firefox\Profiles\*\cache2\entries" } },
        @{ Name = "Internet Explorer"; RegPath = "HKLM:\SOFTWARE\Microsoft\Internet Explorer"; CachePath = { RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8; $null } },
        @{ Name = "Microsoft Edge"; RegPath = "HKLM:\SOFTWARE\Microsoft\Edge"; CachePath = { "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache" } }
        # Additional browsers can be added here
    )

    foreach ($browser in $browsers) {
        if (Test-Path $browser.RegPath) {
            Write-Host "$($browser.Name) detected."
            $cachePath = & $browser.CachePath.Invoke()
            if ($cachePath -and (Test-Path $cachePath)) {
                Remove-Item $cachePath -Recurse -Force
                Write-Host "$($browser.Name) cache cleared."
            } else {
                Write-Host "Cache path for $($browser.Name) not found."
            }
        } else {
            Write-Host "$($browser.Name) not installed."
        }
    }
}

# Function Manage Cache
function Manage-Cache {
    Write-Host "Managing Cache"
    Clear-DnsClientCache
    Write-Host "DNS cache cleared"
}

Export-ModuleMember -Function CacheManagementMenu, Manage-Cache, ClearBrowserCaches
