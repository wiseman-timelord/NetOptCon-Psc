# Script: main.ps1

# Initialization
Set-Location -Path $PSScriptRoot
. .\scripts\network.ps1
. .\scripts\updates.ps1
. .\scripts\cache.ps1
. .\scripts\backup.ps1
. .\scripts\monitor.ps1

# Variables
$global:choice = $null
$global:networkChoice = $null
$global:updateChoice = $null
$global:cacheChoice = $null
$global:backupChoice = $null
$global:serviceStatus = $null
$global:adapter = $null
$global:currentSettings = $null
$global:backupLocation = $null
$global:PF = $null
$global:cachePath = $null
$global:exitMonitor = $false
$global:netAdapters = $null
$global:matchedAdapter = $null
$global:netAdapterName = $null
$global:initialStats = $null
$global:totalReceivedRate = 0
$global:totalSentRate = 0
$global:count = 0
$global:currentStats = $null
$global:avgReceivedRate = 0
$global:avgSentRate = 0
$global:totalReceivedKb = 0
$global:totalSentKb = 0
$global:totalReceivedErrors = 0
$global:totalSentErrors = 0
$global:totalReceivedDiscards = 0
$global:totalSentDiscards = 0


# Get-Admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrator privileges. Please run as Administrator." -ForegroundColor Red
    exit
}

# Function Show Title
function Show-Title {
    Write-Host "`n=====================( Netsetera-Psc )======================"
}

# Function Show Mainmenu
function Show-MainMenu {
    Start-Sleep -Seconds 2 #-- 2 normal, 10 debug
    Clear-Host
    Show-Title
    Write-Host "=======================( Main Menu )========================"
    Write-Host "                    1. Network Tweaks"
    Write-Host "                    2. Windows Updates"
    Write-Host "                    3. Cache Management"
    Write-Host "                    4. Network Testing"
    Write-Host "                   5. Backup And Restore"
    $global:choice = Read-Host "`nSelect, Options=1-5, Return=X: "
    try {
        switch ($global:choice) {
            '1' { NetworkTweaksMenu }
            '2' { WindowsUpdatesMenu }
            '3' { CacheManagementMenu }
            '4' { Select-NetworkAdapters }
            '5' { BackupRestoreMenu }
            'x' { Write-Host "Exiting program..."; exit }
        }
    } catch {
        Write-Host "Error encountered: $_" -ForegroundColor Red
    }
}

# Function Networktweaksmenu
function NetworkTweaksMenu {
	Start-Sleep -Seconds 2
	Clear-Host
    Show-Title
    Write-Host "====================( Network Tweaks )======================"
    Write-Host "               1. Toggle RmSvc Service (10/11)"
    Write-Host "          2. Optimize Wireless Adapter (7/8.1/10/11)"
    Write-Host "          3. Toggle Windows Auto-Tuning (7/8.1/10/11)"
    $networkChoice = Read-Host "`nSelect, Options=1-3, Return=X: "
    switch ($networkChoice) {
        '1' { ToggleRmSvc }
        '2' { OptimizeWirelessAdapter }
        '3' { ToggleWindowsAutoTuning }
        'x' { return }
        default { Write-Host "Invalid choice, try again." -ForegroundColor Red }
    }
}

# Function Windowsupdatesmenu
function WindowsUpdatesMenu {
	Start-Sleep -Seconds 2
	Clear-Host
    Show-Title
    Write-Host "====================( Windows Updates )====================="
    Write-Host "          1. Disable Windows Updates (7/8.1/10/11)"
    Write-Host "           2. Disable Edge Updates (7/8.1/10/11)"
    $updateChoice = Read-Host "`nSelect, Options=1-2, Return=X: "
    switch ($updateChoice) {
        '1' { Disable-WindowsUpdates }
        '2' { DisableEdgeUpdates }
        'x' { return }
        default { Write-Host "Invalid choice, try again." -ForegroundColor Red }
    }
}



# Function Cachemanagementmenu
function CacheManagementMenu {
	Start-Sleep -Seconds 2
	Clear-Host
    Show-Title
    Write-Host "===================( Cache Management )====================="
    Write-Host "              1. Clear DNS Cache (8/8.1/10/11)"
    Write-Host "         2. Clear Multi-Browser Caches (8/8.1/10/11)"
    $cacheChoice = Read-Host "`nSelect, Options=1-3, Return=X: "
    switch ($cacheChoice) {
        '1' { ClearDnsClientCache }
        '2' { ClearBrowserCaches }
        'x' { return }
        default { Write-Host "Invalid choice, try again." -ForegroundColor Red }
    }
}

# Function Select Networkadapters
function Select-NetworkAdapters {
	Start-Sleep -Seconds 2
	Clear-Host
    Show-Title
    Write-Host "====================( Network Testing )====================="
	$Adapters = Get-AllNetworkAdapters
    if ($Adapters.Count -eq 0) {
        Write-Host "No Adapters Found. Exiting..." -ForegroundColor Yellow
        return
    }
    while ($true) {
        Clear-Host
        Write-Host "Network Adapter Monitoring`n" -ForegroundColor Cyan
        for ($index = 0; $index -lt $Adapters.Count; $index++) {
            Write-Host "$($index + 1). $($Adapters[$index].Name)"
        }
        Write-Host "`nSelect, Adapter=1-#, Return=X: " -ForegroundColor Cyan
        $selection = Read-Host "Enter Your Choice"
        switch ($selection.ToUpper()) {
            "x" { return }
            default {
                if ($selection -match "^\d+$" -and $selection -le $Adapters.Count -and $selection -gt 0) {
                    Initialize-Monitor -AdapterName $Adapters[$selection - 1].Name
                    $result = Monitor-AdapterLoop
                    if ($result -eq "Menu") { continue }
                    elseif ($result -eq "Exit") { return }
                } else {
                    Write-Host "Invalid input. Please try again." -ForegroundColor Red
                }
            }
        }
    }
}

# Function Backuprestoremenu
function BackupRestoreMenu {
	Start-Sleep -Seconds 2
	Clear-Host
    Show-Title
    Write-Host "==================( Backup and Restore )===================="
    Write-Host "                   1. Backup Settings"
    Write-Host "                   2. Restore Settings"
    $backupChoice = Read-Host "`nSelect, Options=1-2, Return=X: "
    switch ($backupChoice) {
        '1' { BackupSettings }
        '2' { RestoreSettings }
        'x' { return }
        default { Write-Host "Invalid choice, try again." -ForegroundColor Red }
    }
}

# Main Loop
while ($true) {
    Show-MainMenu
}
Show-MainMenu