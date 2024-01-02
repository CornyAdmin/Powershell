Import-Module Activedirectory

  Import-Csv .\userPW.csv |
	foreach {Set-ADAccountPassword $_.UserName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "<Password>" -Force)}

 Import-Csv .\userPW.csv |
    foreach {set-ADUser $_.UserName -ChangePasswordAtLogon $True}