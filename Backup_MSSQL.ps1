Param (
  [string][Parameter(Mandatory = $true )]$dbserver 
  )


$datetime = (Get-Date -Format FileDateTime)

Backup-SqlDatabase -ServerInstance "$dbserver" -Database "tpcc" -BackupFile "\\dfwlab-data-1\SQL-Backups\$dbserver\$($datetime)-tpcc.bak"

#Write-Host Calculating checksum...
#$hash = Get-FileHash -Algorithm MD5 "\\dfwlab-data-1\SQL-Backups\$dbserver\$($datetime)-tpcc.bak"
#Set-Content -Path "\\dfwlab-data-1\SQL-Backups\$dbserver\$($datetime)-tpcc.bak.MD5" $hash

