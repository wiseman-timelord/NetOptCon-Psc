# Script: backup.ps1

function BackupSettings {
    try {
        $currentSettings = Import-PowerShellDataFile -Path .\scripts\settings.psd1
        $currentSettings | Export-Clixml -Path $currentSettings.BackupLocation
        Write-Host "Settings backed up to $($currentSettings.BackupLocation)"
    } catch {
        Write-Host "Error in backup: $_" -ForegroundColor Red
    }
}

function RestoreSettings {
    try {
        $backupLocation = ".\backup\settingsBackup.psd1"
        if (Test-Path $backupLocation) {
            $restoredSettings = Import-Clixml -Path $backupLocation
            Write-Host "Settings restored from backup"
        } else {
            Write-Host "Backup file not found"
        }
    } catch {
        Write-Host "Error in restore: $_" -ForegroundColor Red
    }
}
