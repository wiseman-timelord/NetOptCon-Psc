# .scripts\settings.psd1
# Configuration settings for NetOptX-Psc

@{
    # Network Optimization Settings
    "AutoTuningLevel" = "default"
    "MaxUserPort" = 65535
    "TcpTimedWaitDelay" = 30

    # Windows Updates Management Settings
    "WindowsUpdateSettings" = @{
        "AutomaticUpdates" = "default"
        # Additional settings can be added here
    }

    # Cache Management Settings
    "CacheLocations" = @{
        "DNSCache" = "N/A"
        "EdgeCache" = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
        # Additional cache locations
    }

    # Backup and Restore Settings
    "BackupLocation" = ".\backup\settingsBackup.psd1"
}
