here is my script, that is part of a program, that optimizes network settings, this specific script is based around monitoring the network card of the users choice, however, to improve the program, we will be turning it into a benchmarking tool, but first, lets simplify the script, so that I dont have to spend the rest of the day on it, please remove all code relating to errors and 

# Script: monitor.ps1

# Variables
$global:totalReceivedRate = 0
$global:totalSentRate = 0
$global:count = 0
$global:avgReceivedRate = 0
$global:avgSentRate = 0
$global:totalReceivedKb = 0
$global:totalSentKb = 0
$global:totalReceivedErrors = 0
$global:totalSentErrors = 0
$global:totalReceivedDiscards = 0
$global:totalSentDiscards = 0


# Function Reset Monitorvariables
function Reset-MonitorVariables {
    $global:totalReceivedRate = 0
    $global:totalSentRate = 0
    $global:count = 0
    $global:avgReceivedRate = 0
    $global:avgSentRate = 0
    $global:totalReceivedKb = 0
    $global:totalSentKb = 0
    $global:totalReceivedErrors = 0
    $global:totalSentErrors = 0
    $global:totalReceivedDiscards = 0
    $global:totalSentDiscards = 0
}

# Function Get Allnetworkadapters
function Get-AllNetworkAdapters {
    Get-WmiObject -Class Win32_NetworkAdapter | Where-Object { $_.NetEnabled -eq $true } | Select-Object NetConnectionID, Name
}

# Function Select NetworkAdapters
function Select-NetworkAdapters {
    Start-Sleep -Seconds 2
    Clear-Host
    Show-Title
    Write-Host "====================( Network Testing )====================="
    try {
        $Adapters = Get-AllNetworkAdapters
        if ($Adapters.Count -eq 0) {
            Write-Host "No Adapters Found. Exiting..." -ForegroundColor Yellow
            return
        }
        while ($true) {
            Clear-Host
			Write-Host "====================( Network Testing )====================="
            Write-Host "Monitoring Network Adapter...`n" -ForegroundColor Cyan
            for ($index = 0; $index -lt $Adapters.Count; $index++) {
                Write-Host "$($index + 1). $($Adapters[$index].Name)"
            }
            Write-Host "`nSelect, Adapter=1-#, Return=X" -ForegroundColor Cyan
            $selection = Read-Host "Enter Your Choice"
            switch ($selection.ToUpper()) {
                "x" { return }
                default {
                    if ($selection -match "^\d+$" -and $selection -le $Adapters.Count -and $selection -gt 0) {
                        Initialize-Monitor -AdapterName $Adapters[$selection - 1].Name
                        $result = Monitor-AdapterLoop
                        if ($result -eq "Menu") { continue }
                        elseif ($result -eq "Exit") { return }
                    } else {
                        Write-Host "Invalid input. Please try again." -ForegroundColor Red
                    }
                }
            }
        }
    } catch {
        Write-Host "Error encountered: $_" -ForegroundColor Red
    }
}

# Function Initialize Monitor
function Initialize-Monitor {
    param (
        [string] $AdapterName
    )
    $global:wmiAdapters = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object { $_.NetEnabled -eq $true }
    $global:netAdapters = Get-NetAdapter
    $global:matchedAdapter = $global:wmiAdapters | Where-Object { $_.Name -eq $AdapterName }
    if ($null -eq $global:matchedAdapter) {
        Write-Host "Adapter '$AdapterName' not found." -ForegroundColor Yellow
        $global:exitMonitor = $true
        return
    }
    $global:netAdapterName = ($global:netAdapters | Where-Object { $_.InterfaceDescription -eq $global:matchedAdapter.Description }).Name
    if ($null -eq $global:netAdapterName) {
        Write-Host "NetAdapter Name mapping not found for '$AdapterName'." -ForegroundColor Yellow
        $global:exitMonitor = $true
        return
    }
    $global:initialStats = Get-NetAdapterStatistics -Name $global:netAdapterName
    $global:initialReceivedBytes = $global:initialStats.ReceivedBytes
    $global:initialSentBytes = $global:initialStats.SentBytes
}

# Function Monitor Adapterloop
function Monitor-AdapterLoop {
    do {
        Clear-Host
        Write-Host "`nMonitoring Device: $($global:netAdapterName)`n"
        $startTime = Get-Date
        while ((Get-Date) -lt $startTime.AddSeconds(60)) {
			Clear-Host
            Write-Host "`nMonitoring Device: $($global:netAdapterName)`n"
            $global:currentStats = Get-NetAdapterStatistics -Name $global:netAdapterName
            $receivedRate = [math]::Floor(($global:currentStats.ReceivedBytes - $global:initialReceivedBytes) / 5 / 1024)
            $sentRate = [math]::Floor(($global:currentStats.SentBytes - $global:initialSentBytes) / 5 / 1024)
            $global:totalReceivedRate += $receivedRate
            $global:totalSentRate += $sentRate
            $global:count++
            $global:totalReceivedKb = [math]::Floor(($global:currentStats.ReceivedBytes - $global:initialReceivedBytes) / 1024)
            $global:totalSentKb = [math]::Floor(($global:currentStats.SentBytes - $global:initialSentBytes) / 1024)
            $global:totalReceivedErrors += $global:currentStats.ReceivedErrors ?? 0
            $global:totalSentErrors += $global:currentStats.SentErrors ?? 0
            $global:totalReceivedDiscards += $global:currentStats.ReceivedDiscards ?? 0
            $global:totalSentDiscards += $global:currentStats.SentDiscards ?? 0
            Write-Host "Current Data In: $receivedRate KB/s, Total Data In: $($global:totalReceivedKb) KB"
            Write-Host "Current Data Out: $sentRate KB/s, Total Data Out: $($global:totalSentKb) KB"
            Write-Host "Current Errors In: $($global:totalReceivedErrors), Current Discards In: $($global:totalReceivedDiscards)"
            Write-Host "Current Errors Out: $($global:totalSentErrors), Current Discards Out: $($global:totalSentDiscards)"
            Start-Sleep -Seconds 5
        }
        $global:avgReceivedRate = [math]::Floor($global:totalReceivedRate / $global:count)
        $global:avgSentRate = [math]::Floor($global:totalSentRate / $global:count)
        Clear-Host
        Write-Host "`nMonitored Device: $($global:netAdapterName)`n"
        Write-Host "Average Data In: $($global:avgReceivedRate) KB/s, Total Data In: $($global:totalReceivedKb) KB"
        Write-Host "Total Errors In: $($global:totalReceivedErrors), Total Discards In: $($global:totalReceivedDiscards)"
		Write-Host "Average Data Out: $($global:avgSentRate) KB/s, Total Data Out: $($global:totalSentKb) KB"
        Write-Host "Total Errors Out: $($global:totalSentErrors), Total Discards Out: $($global:totalSentDiscards)"
        Write-Host "`nOptions: [R]estart Monitoring, [M]enu" -ForegroundColor Cyan
        $choice = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()

        switch ($choice) {
            "r" {
                Reset-MonitorVariables
                Start-Sleep -Seconds 5    
                break 
            }
            "m" { 
                return "Menu" 
            }
            default { 
                Write-Host "`nInvalid option. Please choose again." -ForegroundColor Red 
                Start-Sleep -Seconds 2 
                break 
            }
        }
    } while ($true)
}
