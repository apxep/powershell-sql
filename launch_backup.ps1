$dbHosts = "jhsqldemo01","jhsqldemo02","jhsqldemo03","jhsqldemo04","dfwsql01"
#$dbHosts = "dfwsql01"

foreach ($thisServer in $dbHosts) {
  $proc = Start-Process -FilePath "powershell" -ArgumentList "-file Backup_MSSQL.ps1 -dbserver $thisServer"
  Start-Sleep -Seconds 10
}
