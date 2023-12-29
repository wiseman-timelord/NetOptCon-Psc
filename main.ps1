# Script: main.ps1

# Initialization
Set-Location -Path $PSScriptRoot
. .\scripts\settings.psd1
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

# Function Reset Monitorvariables
function Reset-MonitorVariables {
    $global:totalReceivedRate = 0
    $global:totalSentRate = 0
    $global:count = 0
    $global:avgReceivedRate = 0
    $global:avgSentRate = 0
    $global:totalReceivedKb = 0
    $global:totalSentKb = 0
    $global:totalReceivedErrors = 0
    $global:totalSentErrors = 0
    $global:totalReceivedDiscards = 0
    $global:totalSentDiscards = 0
}

# Function Show Title
function Show-Title {
    Write-Host "`n====================( NetOptSet-Psc )======================`n"
}

# Function Show Mainmenu
function Show-MainMenu {
    Start-Sleep -Seconds 10 #-- 2 normal, 10 debug
	Clear-Host
	Show-Title
    Write-Host "Network Optimization and Configuration Management"
    Write-Host "1. Network Tweaks and Optimization"
    Write-Host "2. Windows Updates Management"
    Write-Host "3. Cache Management"
	Write-Host "4. Network Monitoring"
    Write-Host "5. Backup and Restore Settings"
    Write-Host "6. Exit"
    $global:choice = Read-Host "Please enter your choice"
    try {
        switch (${global}:choice) {
            '1' { Invoke-NetworkTweaks }
            '2' { Manage-WindowsUpdates }
            '3' { Manage-Cache }
            '4' { Select-NetworkAdapters }  # New option for Network Monitoring
            '5' { BackupRestore-Settings }
            '6' { Write-Host "Exiting program... Goodbye!"; exit }
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
	Start-Sleep -Seconds 2
	Clear-Host
    Show-Title
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
	Start-Sleep -Seconds 2
	Clear-Host
    Show-Title
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


# Function Select Networkadapters
function Select-NetworkAdapters {
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
        Write-Host "`nSelect Adapter '1-#', Exit 'X':" -ForegroundColor Cyan
        $selection = Read-Host "Enter Your Choice"
        switch ($selection.ToUpper()) {
            "X" { return }
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