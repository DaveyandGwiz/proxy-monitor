# Define the function to monitor and enforce proxy settings
function MonitorProxySettings {
    # Get the current value of "Automatically detect settings"
    $autoDetectValue = Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name AutoDetect

    # If "Automatically detect settings" is not enabled, print an alert message and set it back to enabled
    if ($autoDetectValue -ne 1) {
        Write-Host "Alert: Proxy settings have changed."
        Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name AutoDetect -Value 1
    }
}

# Define the service loop
while ($true) {
    # Monitor and enforce proxy settings
    MonitorProxySettings
    # Sleep for 60 seconds before checking again
    Start-Sleep -Seconds 60
}
