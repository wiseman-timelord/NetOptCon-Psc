# Script: main.ps1

# Initialization
. .\scripts\ascii.ps1
. .\scripts\settings.psd1
. .\scripts\network.ps1
. .\scripts\updates.ps1
. .\scripts\cache.ps1
. .\scripts\backup.ps1

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

# Get-Admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrator privileges. Please run as Administrator." -ForegroundColor Red
    exit
}

# Function Show Mainmenu
function Show-MainMenu {
    Clear-Host
    Write-Host "====================( NetOptSet-Psc )======================"	
    Write-Host "Network Optimization and Configuration Management"
    Write-Host "1. Network Tweaks and Optimization"
    Write-Host "2. Windows Updates Management"
    Write-Host "3. Cache Management"
    Write-Host "4. Backup and Restore Settings"
    Write-Host "5. Exit"
    $global:choice = Read-Host "Please enter your choice"
    try {
        switch ($global:choice) {
            '1' { Invoke-NetworkTweaks }
            '2' { Manage-WindowsUpdates }
            '3' { Manage-Cache }
            '4' { BackupRestore-Settings }
            '5' { Write-Host "Exiting program... Goodbye!"; exit }
            default { Write-Host "Invalid choice, try again." -ForegroundColor Red }
        }
    } catch {
        Write-Host "Error encountered: $_" -ForegroundColor Red
    }
}

# Function Networktweaksmenu
function NetworkTweaksMenu {
    Write-Host "====================( NetOptSet-Psc )======================"
    Write-Host "Network Tweaks and Optimization:"
    Write-Host "1. Toggle RmSvc Service"
    Write-Host "2. Flush DNS Cache"
    Write-Host "3. Optimize Wireless Adapter Settings"
    Write-Host "4. Toggle Windows Auto-Tuning"
    Write-Host "5. Return to Main Menu"
    $networkChoice = Read-Host "Enter your choice"
    switch ($networkChoice) {
        '1' { ToggleRmSvc }
        '2' { FlushDnsCache }
        '3' { OptimizeWirelessAdapter }
        '4' { ToggleWindowsAutoTuning }
        '5' { return }
        default { Write-Host "Invalid choice, try again." -ForegroundColor Red }
    }
}

# Function Windowsupdatesmenu
function WindowsUpdatesMenu {
    Write-Host "====================( NetOptSet-Psc )======================"
    Write-Host "Windows Updates Management:"
    Write-Host "1. Check and Install Updates"
    Write-Host "2. Disable Edge Updates"
    Write-Host "3. Return to Main Menu"
    $updateChoice = Read-Host "Enter your choice"
    switch ($updateChoice) {
        '1' { Manage-WindowsUpdates }
        '2' { DisableEdgeUpdates }
        '3' { return }
        default { Write-Host "Invalid choice, try again." -ForegroundColor Red }
    }
}

# Function Cachemanagementmenu
function CacheManagementMenu {
    Write-Host "====================( NetOptSet-Psc )======================"
    Write-Host "Cache Management:"
    Write-Host "1. Clear DNS Cache"
    Write-Host "2. Clear Browser Caches"
    Write-Host "3. Return to Main Menu"
    $cacheChoice = Read-Host "Enter your choice"
    switch ($cacheChoice) {
        '1' { ClearDnsClientCache }
        '2' { ClearBrowserCaches }
        '3' { return }
        default { Write-Host "Invalid choice, try again." -ForegroundColor Red }
    }
}

# Function Backuprestoremenu
function BackupRestoreMenu {
    Write-Host "====================( NetOptSet-Psc )======================"
    Write-Host "Backup and Restore Settings:"
    Write-Host "1. Backup Current Settings"
    Write-Host "2. Restore Settings from Backup"
    Write-Host "3. Return to Main Menu"
    $backupChoice = Read-Host "Enter your choice"
    switch ($backupChoice) {
        '1' { BackupSettings }
        '2' { RestoreSettings }
        '3' { return }
        default { Write-Host "Invalid choice, try again." -ForegroundColor Red }
    }
}


# Main Loop
while ($true) {
    Show-MainMenu
}
Show-AsciiBanner
Show-MainMenu