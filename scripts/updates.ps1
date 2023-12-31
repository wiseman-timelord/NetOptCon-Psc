# Script: updates.ps1

# Function Disable Windowsupdates
function Disable-WindowsUpdates {
    Write-Host "Disabling Windows Updates..."
    try {
        sc.exe config wuauserv start=disabled
        sc.exe stop wuauserv
        sc.exe query wuauserv
        $regStatus = REG.exe QUERY HKLM\SYSTEM\CurrentControlSet\Services\wuauserv /v Start
        if ($regStatus -like '*0x4*') {
            Write-Host "...Windows Update Service Disabled."
        } else {
            Write-Host "...Failed to Disable Windows Update Service."
        }
    } catch {
        Write-Host "...Error Occurred: $_"
    }
    Start-Sleep -Seconds 2
}

# Function Disableedgeupdates
function DisableEdgeUpdates {
    Write-Host "Disabling Edge Updates..."
    try {
        $PF = if ([Environment]::Is64BitOperatingSystem) { ${env:ProgramFiles(x86)} } else { $env:ProgramFiles }
        $edgePath = "$PF\Microsoft\Edge\Application\msedge.exe"
        if (Test-Path $edgePath) {
            Get-Process "MicrosoftEdgeUpdate", "msedge", "edgeupdate", "edgeupdatem", "MicrosoftEdgeElevationService" -ErrorAction SilentlyContinue | Stop-Process -Force
            "BrowserReplacementTask", "TaskMachineCore", "TaskMachineUA" | ForEach-Object { schtasks.exe /Delete /TN "\MicrosoftEdgeUpdate$_" /F }
            Remove-Item "$PF\Microsoft\EdgeUpdate" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "...Microsoft Edge Updates Disabled."
        } else {
            Write-Host "...Microsoft Edge Not Installed."
        }
    } catch {
        Write-Host "...Error Disabling Edge Updates: $_" -ForegroundColor Red
    }
    Start-Sleep -Seconds 2
}
