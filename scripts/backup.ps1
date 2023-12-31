# Script: backup.ps1

# Function Backupsettings
function BackupSettings {
    try {
        Write-Host "Starting Backup..."
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
        Write-Host "...Backup Complete."
        Start-Sleep -Seconds 2
    } catch {
        Write-Host "Error in backup: $_" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}

# Function Restoresettings
function RestoreSettings {
    try {
        Write-Host "Restoring Settings..."
        $backupLocation = ".\backup\settingsBackup.psd1"
        if (Test-Path $backupLocation) {
            $restoredSettings = Import-Clixml -Path $backupLocation
            Write-Host "...Settings Restored."
            Start-Sleep -Seconds 2
        } else {
            Write-Host "Backup File Not Found."
            Start-Sleep -Seconds 2
        }
    } catch {
        Write-Host "Error in restore: $_" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}
