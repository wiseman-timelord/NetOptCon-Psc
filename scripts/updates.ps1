# Script: updates.ps1

# Function Manage Windowsupdates
function Disable-WindowsUpdates {
    try {
        sc.exe config wuauserv start=disabled
        sc.exe stop wuauserv
        sc.exe query wuauserv
        $regStatus = REG.exe QUERY HKLM\SYSTEM\CurrentControlSet\Services\wuauserv /v Start
        if ($regStatus -like '*0x4*') {
            Write-Host "Windows Update service disabled successfully."
        } else {
            Write-Host "Failed to disable Windows Update service."
        }
    } catch {
        Write-Host "Error occurred: $_"
    }
}


function DisableEdgeUpdates {
    try {
        $PF = if ([Environment]::Is64BitOperatingSystem) { ${env:ProgramFiles(x86)} } else { $env:ProgramFiles }
        $edgePath = "$PF\Microsoft\Edge\Application\msedge.exe"

        if (Test-Path $edgePath) {
            Get-Process "MicrosoftEdgeUpdate", "msedge", "edgeupdate", "edgeupdatem", "MicrosoftEdgeElevationService" -ErrorAction SilentlyContinue | Stop-Process -Force
            "BrowserReplacementTask", "TaskMachineCore", "TaskMachineUA" | ForEach-Object { schtasks.exe /Delete /TN "\MicrosoftEdgeUpdate$_" /F }
            Remove-Item "$PF\Microsoft\EdgeUpdate" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Microsoft Edge updates disabled successfully."
        } else {
            Write-Host "Microsoft Edge is not installed."
        }
    } catch {
        Write-Host "Error disabling Edge updates: $_" -ForegroundColor Red
    }
}
