# Windows Proxy Settings Monitor Service

This repo is for a PowerShell script to be used with NSSM to create a background Windows service.
This service prevents default Windows Proxy configurations from changing and logs activity to a file.
The service scans the Windows registry for the value of "automatically detect settings" under Proxy Settings. 
The script monitors this value, reverts it back to enabled if changed, and stores activity to a log file.

Author: LostBooks