#$OUs = import-csv .\OUs.csv
$OUs = Get-ADOrganizationalUnit -Filter 'Name -like "*"' -SearchBase '<BaseDN>' | Select DistinguishedName

Foreach ($Ou in $OUs)
  {
    $DN = $Ou.DistinguishedName
    #Get-ADOrganizationalUnit $DN | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$False
    Get-ADOrganizationalUnit $DN
  }