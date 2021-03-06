@echo off

echo Syncing time
tzutil /s "utc"
w32tm /config /syncfromflags:manual /manualpeerlist:0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org

echo Increasing limits for remote shells
call winrm set winrm/config/winrs @{MaxMemoryPerShellMB="8192"}
call winrm set winrm/config/winrs @{MaxProcessesPerShell="512"}
call winrm set winrm/config/winrs @{MaxShellsPerUser="128"}
call winrm set winrm/config/winrs @{IdleTimeout="86400000"}
call winrm set winrm/config @{MaxTimeoutms="86400000"}

rem Increase limits for remote shells
PowerShell Set-Item WSMan:\localhost\Shell\MaxMemoryPerShellMB 8192
PowerShell Set-Item WSMan:\localhost\Plugin\Microsoft.PowerShell\Quotas\MaxMemoryPerShellMB 8192
PowerShell Set-Item WSMan:\localhost\Shell\MaxProcessesPerShell 512
PowerShell Set-Item WSMan:\localhost\Plugin\Microsoft.PowerShell\Quotas\MaxProcessesPerShell 512
PowerShell Set-Item WSMan:\localhost\Shell\MaxShellsPerUser 128
PowerShell Set-Item WSMan:\localhost\Plugin\Microsoft.PowerShell\Quotas\MaxShellsPerUser 128
rem PowerShell Restart-Service winrm
