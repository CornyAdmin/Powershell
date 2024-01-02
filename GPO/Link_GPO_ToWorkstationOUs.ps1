Import-Module ActiveDirectory
$GPOName = "<GPOName>"

$OUs = Get-ADOrganizationalUnit -Filter 'Name -like "workstations"' | Select DistinguishedName

ForEach ($OU in $OUs)
  {
    $OUDN = $OU.DistinguishedName
    Write-Host "Linking GPO to: " $OUDN
    New-GPLink -Name $GPOName -Target $OUDN -LinkEnabled Yes
  }