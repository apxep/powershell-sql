$dbHosts = "jhsqldemo01","jhsqldemo02","jhsqldemo03","jhsqldemo04","dfwsql01"

#$dbHosts = "dfwsql01"

while ($true) {
  $currentdate = Get-Date

  foreach ($thisServer in $dbHosts) {
    $lastboot = (Get-CimInstance -CimSession $thisServer -ClassName Win32_OperatingSystem).LastBootUpTime

    $uptime = $currentdate - $lastboot

    $upstring = "$($uptime.days) Days, $($uptime.hours) Hrs, $($uptime.minutes) Min, and $($uptime.seconds) Sec"

    Write-Host "server = $thisServer"
#    Invoke-Sqlcmd -ServerInstance "$thisServer" -Database tpcc -QueryTimeout 3 -Query "INSERT INTO dbo.timeseries VALUES (NEXT VALUE FOR timeseries_seq,'$(( Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime)','$upstring','$thisServer');"
    Invoke-Sqlcmd -ServerInstance "$thisServer" -Database tpcc -QueryTimeout 3 -Query "INSERT INTO dbo.timeseries VALUES (NEXT VALUE FOR timeseries_seq,'$lastboot','$upstring','$thisServer');"
 
    Invoke-Sqlcmd -ServerInstance "$thisServer" -Database tpcc -QueryTimeout 3 -Query "SELECT TOP (10) * FROM dbo.timeseries ORDER BY sequence DESC;"
    Write-Host "--------------------------------------------------------"

  }
  Start-Sleep -Seconds 1
}