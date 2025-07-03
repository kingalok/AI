function Test-SHIRStatus {
    Write-Host "`n--- SHIR Health Check ---`n"

    # 1. Check if DIAHostService exists and is running
    $service = Get-Service -Name DIAHostService -ErrorAction SilentlyContinue
    if ($service) {
        Write-Host "✅ DIAHostService exists. Status: $($service.Status)"
    } else {
        Write-Warning "❌ DIAHostService not found!"
    }

    # 2. Check if Integration Runtime process is running
    $irProcess = Get-Process | Where-Object { $_.Name -like "*IntegrationRuntime*" }
    if ($irProcess) {
        Write-Host "✅ Integration Runtime process is running: $($irProcess.Name)"
    } else {
        Write-Warning "❌ No Integration Runtime process found!"
    }

    # 3. Check if SHIR is registered (by verifying the config path)
    $cmdPath = Get-ItemPropertyValue -Path "HKLM:\Software\Microsoft\DataTransfer\DataManagementGateway\ConfigurationManager" -Name "DiacmdPath" -ErrorAction SilentlyContinue
    if (![string]::IsNullOrWhiteSpace($cmdPath)) {
        Write-Host "✅ Gateway command path found: $cmdPath"
    } else {
        Write-Warning "❌ SHIR command path not found - Gateway may not be registered"
    }

    # 4. Check log file freshness
    $logPath = "C:\Program Files\Microsoft Integration Runtime\5.0\Shared\Logs"
    if (Test-Path $logPath) {
        $lastLog = Get-ChildItem -Path $logPath -Recurse -Include *.log | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($lastLog) {
            Write-Host "✅ Latest log file: $($lastLog.Name) - Last updated: $($lastLog.LastWriteTime)"
        } else {
            Write-Warning "❌ No recent log files found"
        }
    } else {
        Write-Warning "❌ Log path does not exist"
    }

    # 5. Test outbound internet connectivity
    try {
        $response = Invoke-WebRequest -Uri "https://www.microsoft.com" -UseBasicParsing -TimeoutSec 5
        Write-Host "✅ Outbound internet connectivity OK"
    } catch {
        Write-Warning "❌ Failed to reach Microsoft.com - check outbound firewall or proxy"
    }

    Write-Host "`n--- End of SHIR Health Check ---`n"
}
