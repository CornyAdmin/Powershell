$OUs = Get-ADOrganizationalUnit -Filter 'Name -like "*"' -SearchBase '<BaseDN>' | Select DistinguishedName
$OUs | Export-Csv .\OUs.csv -Encoding "unicode" -NoTypeInformation -Delimiter "`t"