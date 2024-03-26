$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$autoDetectName = "AutoDetect"
$proxyEnableName = "ProxyEnable"
$autoConfigURLName = "AutoConfigURL"

function Monitor-ProxySettings {
    while ($true) {
        # Check AutoDetect setting
        $autoDetect = Get-ItemProperty -Path $registryPath -Name $autoDetectName -ErrorAction SilentlyContinue
        if ($autoDetect -eq $null -or $autoDetect.AutoDetect -eq 0) {
            Write-Host "Alert: 'Automatically detect settings' is turned off. Turning it back on..."
            Set-ItemProperty -Path $registryPath -Name $autoDetectName -Value 1
        }

        # Check ProxyEnable setting
        $proxyEnable = Get-ItemProperty -Path $registryPath -Name $proxyEnableName -ErrorAction SilentlyContinue
        if ($proxyEnable -ne $null -and $proxyEnable.ProxyEnable -eq 1) {
            Write-Host "Alert: A manual proxy has been set up."
        }

        # Check for Proxy Configuration Script
        $autoConfigURL = Get-ItemProperty -Path $registryPath -Name $autoConfigURLName -ErrorAction SilentlyContinue
        if ($autoConfigURL -ne $null -and $autoConfigURL.AutoConfigURL -ne $null) {
            Write-Host "Alert: A proxy configuration script has been set."
            # Optionally, remove the proxy configuration script
            # Remove-ItemProperty -Path $registryPath -Name $autoConfigURLName
        }

        Start-Sleep -Seconds 10
    }
}

Monitor-ProxySettings
