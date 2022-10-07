# the idea here is to check NAS export/shares for POSIX style permissions that have been left, eg root:root with 777.
# Assumes to be run with an administrative permission account

Param(
[string][Parameter(Mandatory = $true )]$myserver
)

$found = 0
$outfile = ".\share_permissions_$(date -Format filedatetime).txt"

Set-Content -Path $outfile -Value "File systems with suspicious permissions as of $(date).`n`n--------------------------------------------------`n" 

# get all SMB shares from the target server and make a list of just share names - TODO: pass specific share as parameter
$allshares = (net view $myserver | Where-Object { $_ -match '\sDisk\s' } ) -replace '\s\s+',',' |ForEach-Object { ($_ -split ',')[0] }

foreach($this_share in $allshares) {
  Write-Host "Checking $this_share :"
  Write-Host "Mounting..."

  New-PSDrive -Name Q -PSProvider FileSystem -Root $myserver\$this_share

  Write-Host "Filesystem contains $(( Get-ChildItem Q:\ | Measure-Object ).Count) items."

  $this_acl = Get-Acl -Path Q:\

  Add-Content -Path $outfile -Value "`n`n-------------------`n$this_share`n-------------------"

  if ( ($this_acl.Owner).contains("S-1-22-1") ) {
    Write-Host -ForegroundColor Red -BackgroundColor Yellow "$this_share MAY BE VULNERABLE - FOUND root owner!!"
    Add-Content -Path $outfile -Value "$this_share MAY BE VULNERABLE - FOUND root owner!!"
  }
  if ( ($this_acl.Group).contains("S-1-22-2" ) ) {
    Write-Host -ForegroundColor Red -BackgroundColor Yellow "$this_share MAY BE VULNERABLE - FOUND root group!!"
    Add-Content -Path $outfile -Value "$this_share MAY BE VULNERABLE - FOUND root group!!"
  }

  if ( ($this_acl.AccessToString) -like "*Everyone*Allow*FullControl*" ) {
    Write-Host -ForegroundColor Red -BackgroundColor Yellow "***  $this_share MAY BE VULNERABLE - FOUND Everyone FULL CONTROL access!!  ***"
    Add-Content -Path $outfile -Value "***  $this_share MAY BE VULNERABLE - FOUND Everyone FULL CONTROL access!!  ***"
  }

  Write-Host "`n`nDONE - Dismount...`n`n"
  Remove-PSDrive -Name Q
}

Write-Host "Done!"
