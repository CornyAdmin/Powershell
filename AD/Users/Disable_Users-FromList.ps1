import-module activedirectory

$Users = cat '.\Users_Disable.txt'

foreach ($User in $Users)
	{
    $User
		Get-ADUser $User | Disable-ADAccount
	}