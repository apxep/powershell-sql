while( $true ) {

$site = "PROD"

$lastboot = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime

$currentdate = Get-Date

$uptime = $currentdate - $lastboot

$upstring = "$($uptime.days) Days, $($uptime.hours) Hrs, $($uptime.minutes) Min, and $($uptime.seconds) Sec"

Invoke-Sqlcmd -ServerInstance "dfwsql01" -Database tpcc -Query "INSERT INTO dbo.timeseries VALUES (NEXT VALUE FOR timeseries_seq,'$(( Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime)','$upstring','$site');"

Invoke-Sqlcmd -ServerInstance "dfwsql01" -Database tpcc -Query "SELECT TOP 20 * FROM dbo.timeseries ORDER BY sequence DESC;"

Write-Host ""
Write-Host "$currentdate"

Start-Sleep -Seconds 5

}


