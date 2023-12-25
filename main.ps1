# Script: main.ps1

# Initialization
. .\scripts\ascii.ps1
. .\scripts\settings.psd1

# Get-Admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrator privileges. Please run as Administrator." -ForegroundColor Red
    exit
}

# Function Show Mainmenu
function Show-MainMenu {
    Clear-Host
    Write-Host "NetOptX-Psc - Network Optimization and Configuration Management"
    Write-Host "1. Network Tweaks and Optimization"
    Write-Host "2. Windows Updates Management"
    Write-Host "3. Cache Management"
    Write-Host "4. Backup and Restore Settings"
    Write-Host "5. Exit"
    $choice = Read-Host "Please enter your choice"
    try {
        switch ($choice) {
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

# Function Togglermsvc
function ToggleRmSvc {
    try {
        $serviceStatus = (Get-Service -Name "RmSvc").Status
        if ($serviceStatus -eq "Running") {
            Set-Service -Name "RmSvc" -StartupType Disabled
            Write-Host "RmSvc service disabled"
        } else {
            Set-Service -Name "RmSvc" -StartupType Automatic
            Write-Host "RmSvc service enabled"
        }
    } catch {
        Write-Host "Error toggling RmSvc: $_" -ForegroundColor Red
    }
}

# Function Optimizewirelessadapter
function OptimizeWirelessAdapter {
    try {
        $adapter = Get-NetAdapter | Where-Object { $_.Name -like '*Wireless*' } | Select-Object -First 1
        if ($adapter) {
            Set-NetAdapterPowerManagement -Name $adapter.Name -WakeOnMagicPacket Enabled
            Write-Host "Wireless adapter settings optimized"
        } else {
            Write-Host "No wireless adapter found"
        }
    } catch {
        Write-Host "Error optimizing wireless adapter: $_" -ForegroundColor Red
    }
}

# Function Togglewindowsautotuning
function ToggleWindowsAutoTuning {
    try {
        netsh int tcp set global autotuninglevel=disabled
        Write-Host "Windows Auto-Tuning disabled"
    } catch {
        Write-Host "Error toggling Windows Auto-Tuning: $_" -ForegroundColor Red
    }
}

# Function Flushdnscache
function FlushDnsCache {
    try {
        Clear-DnsClientCache
        Write-Host "DNS cache cleared"
    } catch {
        Write-Host "Error flushing DNS cache: $_" -ForegroundColor Red
    }
}

# Function Invoke Networktweaks
function Invoke-NetworkTweaks {
    Write-Host "Performing Network Tweaks and Optimization"
	try {
        $serviceStatus = (Get-Service -Name "RmSvc").Status
        if ($serviceStatus -eq "Running") {
            Set-Service -Name "RmSvc" -StartupType Disabled
            Write-Host "RmSvc service disabled"
        } else {
            Set-Service -Name "RmSvc" -StartupType Automatic
            Write-Host "RmSvc service enabled"
        }
        Clear-DnsClientCache
        Write-Host "DNS cache cleared"
        $adapter = Get-NetAdapter | Where-Object { $_.Name -like '*Wireless*' } | Select-Object -First 1
        if ($adapter) {
            Set-NetAdapterPowerManagement -Name $adapter.Name -WakeOnMagicPacket Enabled
            Write-Host "Wireless adapter settings optimized"
        }
        netsh int tcp set global autotuninglevel=disabled
        Write-Host "Windows Auto-Tuning disabled"
    } catch {
        Write-Host "Error in Network Tweaks: $_" -ForegroundColor Red
    }
}

# Function Manage Windowsupdates
function Manage-WindowsUpdates {
    Write-Host "Managing Windows Updates"
    Install-Module -Name PSWindowsUpdate -Force
    Get-WindowsUpdate | Install-WindowsUpdate
    Write-Host "Windows updates managed"
}

# Function Manage Cache
function Manage-Cache {
    Write-Host "Managing Cache"
    Clear-DnsClientCache
    Write-Host "DNS cache cleared"
}

# Function Backuprestore Settings
function BackupRestore-Settings {
    Write-Host "Backup and Restore Settings"
    $settings = @{ "AutoTuningLevel" = "disabled"; "DnsClientCache" = "cleared" }
    $settings | Export-Clixml -Path ".\backup\settingsBackup.xml"
    Write-Host "Settings backed up"
    if (Test-Path ".\backup\settingsBackup.xml") {
        $restoredSettings = Import-Clixml -Path ".\backup\settingsBackup.xml"
        try {
            Write-Host "Settings restored from backup"
        } catch {
            Write-Host "Error in Backup/Restore: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Backup file not found"
    }
}
while ($true) {
    Show-MainMenu
}
Show-AsciiBanner
Show-MainMenu
