# Define the path to the registry key
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$registryName = "AutoDetect"

# Function to check and update the proxy setting
function CheckAndUpdateProxySetting {
    $autoDetect = Get-ItemProperty -Path $registryPath -Name $registryName | Select-Object -ExpandProperty $registryName
    if ($autoDetect -eq 0) {
        Write-Host "Alert: Proxy settings have changed"
        Set-ItemProperty -Path $registryPath -Name $registryName -Value 1
        Write-Host "Automatically detect settings has been re-enabled."
    }
}

# Initial check
CheckAndUpdateProxySetting

# Setup a file system watcher to monitor changes to the registry key
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = [System.IO.Path]::GetDirectoryName($registryPath)
$watcher.Filter = [System.IO.Path]::GetFileName($registryPath)
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite
$watcher.EnableRaisingEvents = $true

# Define the action to take when the event is triggered
$action = {
    CheckAndUpdateProxySetting
}

# Subscribe to the changed event
Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $action

# Keep the script running
while ($true) {
    Start-Sleep -Seconds 10
}
