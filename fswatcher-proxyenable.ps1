# Define the function to handle registry change events
function HandleRegistryChangeEvent {
    $event = $event.SourceEventArgs.NewEvent
    $eventName = $event.SourceIdentifier
    $propertyName = $event.PropertyName
    $registryPath = $event.KeyPath

    # Check if the registry path and property name match our target
    if ($registryPath -eq 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -and $propertyName -eq 'ProxyEnable') {
        # Print an alert message to the console
        Write-Host "Alert: Proxy settings have changed."
        # Set ProxyEnable back to 1 (enabled)
        Set-ItemProperty -Path $registryPath -Name 'ProxyEnable' -Value 1
    }
}

# Register for Registry change event
Register-WmiEvent -Query "SELECT * FROM RegistryValueChangeEvent WHERE Hive='HKEY_CURRENT_USER' AND KeyPath='Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings' AND ValueName='ProxyEnable'" -Action {
    # Call the function to handle registry change events
    HandleRegistryChangeEvent
}

# Wait indefinitely for events
try {
    Wait-Event -Timeout ([System.Threading.Timeout]::Infinite)
} finally {
    # Unregister the event watcher when the script exits
    Get-EventSubscriber | Unregister-Event
}
