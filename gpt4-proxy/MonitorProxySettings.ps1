# Define the path and value name for the registry key that controls "Automatically detect settings"
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$valueName = "AutoDetect"

function Monitor-ProxySettings {
    while ($true) {
        # Read the current value of the "Automatically detect settings" option
        $autoDetect = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

        if ($autoDetect -eq $null) {
            Write-Host "The registry key or value does not exist. Please check the path and value name."
            break
        }

        # Check if the "Automatically detect settings" is turned off (value is 0)
        if ($autoDetect.AutoDetect -eq 0) {
            Write-Host "Alert: 'Automatically detect settings' is turned off. Turning it back on..."
            # Set the value back to 1 to turn on "Automatically detect settings"
            Set-ItemProperty -Path $registryPath -Name $valueName -Value 1
        }

        # Wait for a specified time interval before checking again
        Start-Sleep -Seconds 10
    }
}

# Call the function to start monitoring
Monitor-ProxySettings
