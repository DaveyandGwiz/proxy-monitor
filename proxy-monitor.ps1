# Questions:
# * How do I actually navigate to the registry?
# * Should I use ServiceProcessInstaller or NSSM or both?
# * What is this class Microsoft.Win32.RegistryKeyWatcher?


# Define the registry path
$registryPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

# Function to monitor the registry key and change its value if necessary
function Monitor-ProxyRegistry {
    # Create a registry watcher
    $watcher = New-Object Microsoft.Win32.RegistryKeyWatcher
    $watcher.Path = $registryPath
    $watcher.Filter = "ProxyEnable"
    $watcher.NotifyFilter = [Microsoft.Win32.RegistryNotifyFilters]::Value
    $watcher.IncludeSubKeys = $false

    # Define the event action
    $action = {
        $eventName = $Event.SourceEventArgs.Name
        $eventValue = (Get-ItemProperty -Path $registryPath).ProxyEnable
        if ($eventValue -ne 0) {
            Set-ItemProperty -Path $registryPath -Name ProxyEnable -Value 0
            Write-Host "ProxyEnable value changed to 0."
        }
    }

    # Register the event
    Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $action

    # Start the monitoring loop
    while ($true) {
        Start-Sleep -Seconds 1  # Adjust the sleep time if needed
    }
}

# Create a new service
$service = New-Object System.ServiceProcess.ServiceController("ProxyMonitorService")

# Check if the service exists
if (-not $service) {
    Write-Host "Creating Proxy Monitor Service..."

    # Create the service
    $serviceProcessInstaller = New-Object System.ServiceProcess.ServiceProcessInstaller
    $serviceProcessInstaller.Account = [System.ServiceProcess.ServiceAccount]::LocalSystem

    $serviceInstaller = New-Object System.ServiceProcess.ServiceInstaller
    $serviceInstaller.DisplayName = "Proxy Monitor Service"
    $serviceInstaller.Description = "Monitors and controls the ProxyEnable registry key."
    $serviceInstaller.StartType = [System.ServiceProcess.ServiceStartMode]::Automatic
    $serviceInstaller.ServiceName = "ProxyMonitorService"

    $serviceInstaller.Install($serviceProcessInstaller, $serviceInstaller)

    # Set up the service to run the monitoring function
    $service = Get-Service -Name "ProxyMonitorService"
    $service | Set-Service -StartupType Automatic
    $service | Start-Service

    Write-Host "Proxy Monitor Service created and started."
} else {
    Write-Host "Proxy Monitor Service already exists."
}

# Start monitoring the registry
Monitor-ProxyRegistry
