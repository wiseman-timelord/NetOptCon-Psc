# Script: updates.ps1

# Function Manage Windowsupdates
function Manage-WindowsUpdates {
    Install-Module -Name PSWindowsUpdate -Force -ErrorAction SilentlyContinue
    Get-WindowsUpdate | Install-WindowsUpdate -ErrorAction SilentlyContinue
    Write-Host "Windows updates managed"
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

Export-ModuleMember -Function WindowsUpdatesMenu, Manage-WindowsUpdates, DisableEdgeUpdates
