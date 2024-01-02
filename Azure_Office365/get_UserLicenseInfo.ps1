$colObj = @()

$LicenseExtracts = Get-MsolUser -all | where {$_.IsLicensed -eq "True" } |select UserPrincipalName,IsLicensed -ExpandProperty Licenses

foreach ($LicenseExtract in $LicenseExtracts)
	{
    $obj = New-Object System.Object
    $UPN = $LicenseExtract.UserPrincipalName
    $AccountSkuId = $LicenseExtract.AccountSkuId
    $obj | Add-Member -type NoteProperty -name UserPrincipalName -Value $UPN
    $obj | Add-Member -type NoteProperty -name AccountSkuId -Value $AccountSkuId
    $colObj += $obj
	}

$colObj | export-csv '.\LicensedUsers_O365.csv' -NoTypeInformation -Encoding "unicode" -Delimiter "`t" -ErrorAction SilentlyContinue