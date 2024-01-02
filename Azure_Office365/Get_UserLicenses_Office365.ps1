Get-MsolUser -All | where {$_.IsLicensed -eq "True" } |select UserPrincipalName,IsLicensed -ExpandProperty Licenses  |  export-csv c:\scripts\LicensedUsers_O365.csv -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue