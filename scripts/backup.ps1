# Script: backup.ps1

function BackupSettings {
    try {
        $settingsToBackup = @{
            "AutoTuningLevel" = netsh int tcp show global | Select-String "autotuninglevel" -SimpleMatch | Out-String
            "RmSvcServiceStatus" = (Get-Service -Name "RmSvc").Status
            "WirelessAdapterPowerManagement" = Get-NetAdapterPowerManagement | Where-Object { $_.Name -like '*Wireless*' } | Select-Object -First 1
            "WindowsUpdateSettings" = @{
                "AutomaticUpdates" = (Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU").NoAutoUpdate
                "EdgeUpdatesDisabled" = Test-Path "$env:ProgramFiles\Microsoft\EdgeUpdate"
            }
            "CacheLocations" = @{
                "DNSCache" = "N/A"
                "EdgeCache" = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
            }
        }
        $settingsToBackup | Export-Clixml -Path $settingsToBackup.BackupLocation
        Write-Host "Settings backed up to $($settingsToBackup.BackupLocation)"
    } catch {
        Write-Host "Error in backup: $_" -ForegroundColor Red
    }
}

function RestoreSettings {
    try {
        $backupLocation = ".\backup\settingsBackup.psd1"
        if (Test-Path $backupLocation) {
            $restoredSettings = Import-Clixml -Path $backupLocation
            # Implement the logic to restore each setting based on the saved values in $restoredSettings
            Write-Host "Settings restored from backup"
        } else {
            Write-Host "Backup file not found"
        }
    } catch {
        Write-Host "Error in restore: $_" -ForegroundColor Red
    }
}