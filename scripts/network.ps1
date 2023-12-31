# Script: network.ps1

# Function Togglermsvc
function ToggleRmSvc {
    Write-Host "Toggling RmSvc..."
    try {
        $serviceStatus = (Get-Service -Name "RmSvc").Status
        if ($serviceStatus -eq "Running") {
            Set-Service -Name "RmSvc" -StartupType Disabled
            Write-Host "...RmSvc Service Disabled."
        } else {
            Set-Service -Name "RmSvc" -StartupType Automatic
            Write-Host "...RmSvc Service Enabled."
        }
        Start-Sleep -Seconds 2
    } catch {
        Write-Host "...Error Toggling RmSvc: $_" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}

# Function Optimizewirelessadapter
function OptimizeWirelessAdapter {
    Write-Host "Optimizing Wireless Adapter..."
    try {
        $adapter = Get-NetAdapter | Where-Object { $_.Name -like '*Wireless*' } | Select-Object -First 1
        if ($adapter) {
            Set-NetAdapterPowerManagement -Name $adapter.Name -WakeOnMagicPacket Enabled
            Write-Host "...Wireless Adapter Optimized."
        } else {
            Write-Host "...No Wireless Adapter Found."
        }
        Start-Sleep -Seconds 2
    } catch {
        Write-Host "...Error Optimizing Wireless Adapter: $_" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}

# Function Togglewindowsautotuning
function ToggleWindowsAutoTuning {
    Write-Host "Toggling Windows Auto-Tuning..."
    try {
        netsh int tcp set global autotuninglevel=disabled
        Write-Host "...Windows Auto-Tuning Disabled."
        Start-Sleep -Seconds 2
    } catch {
        Write-Host "...Error Toggling Windows Auto-Tuning: $_" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}