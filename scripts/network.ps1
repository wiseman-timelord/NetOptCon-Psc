# Script: network.ps1

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
