$AccountSkuId1 = "<LicenseType>"

$Users = Import-Csv '.\Remove_License.csv'
$Users | ForEach-Object {
    $_.UserPrincipalName
    Set-MsolUserLicense -UserPrincipalName $_.UserPrincipalName -RemoveLicenses $AccountSkuId1
  }