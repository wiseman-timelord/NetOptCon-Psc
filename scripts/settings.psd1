@{
    # Network Optimization Settings
    "AutoTuningLevel" = "default"
    "RmSvcServiceStatus" = "default"
    "WirelessAdapterPowerManagement" = "default"

    # Windows Updates Management Settings
    "WindowsUpdateSettings" = @{
        "AutomaticUpdates" = "default"
        "EdgeUpdatesDisabled" = $false
    }

    # Cache Management Settings
    "CacheLocations" = @{
        "DNSCache" = "N/A"
        "EdgeCache" = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
    }

    # Backup and Restore Settings
    "BackupLocation" = ".\backup\settingsBackup.psd1"
}