# GreenShell Marker Script - PowerShell (Safe, Max Detail)
$MarkerFile = "$env:USERPROFILE\greenshell_marker.txt"

# Basic system info
$UserName = $env:USERNAME
$HostName = $env:COMPUTERNAME
$OSInfo = (Get-CimInstance Win32_OperatingSystem | 
           Select-Object Caption, Version, BuildNumber | 
           Format-Table -HideTableHeaders | Out-String).Trim()
$DateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$IPAddr = (Get-NetIPAddress -AddressFamily IPv4 | 
           Where-Object {$_.InterfaceAlias -notmatch "Loopback"} | 
           Select-Object -First 1 -ExpandProperty IPAddress)

# System uptime
$UptimeInfo = (Get-CimInstance Win32_OperatingSystem | 
               ForEach-Object { (Get-Date) - $_.LastBootUpTime })

# Top 5 CPU processes
$TopProcesses = Get-Process | Sort-Object CPU -Descending | 
                Select-Object -First 5 | 
                ForEach-Object { "$($_.ProcessName):$([math]::Round($_.CPU,2)) CPU" } -join ","

# Disk usage (C:)
$Disk = Get-PSDrive C
$DiskUsage = "$([math]::Round($Disk.Used/1GB,2)) GB used / $([math]::Round($Disk.Size/1GB,2)) GB total"

# Logged in users
$LoggedUsers = query user | ForEach-Object { ($_ -split "\s+")[0] } | Select-Object -Unique | -join ","

# Write all info to file
@"
[GreenShell Marker - Detailed]
User: $UserName
Host: $HostName
OS: $OSInfo
Executed: $DateTime
IP: $IPAddr
Uptime: $UptimeInfo
DiskUsage: $DiskUsage
TopProcesses: $TopProcesses
LoggedUsers: $LoggedUsers
"@ | Out-File -FilePath $MarkerFile -Encoding UTF8

Write-Host "Detailed GreenShell marker created at $MarkerFile"
