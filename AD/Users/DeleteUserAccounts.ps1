$Users = Import-Csv '.\UserList.csv'

Foreach ($User in $Users)
  {
    $User.sAMAccountName
    #Get-ADUser -Identity $User.sAMAccountName | Remove-ADUser -Confirm:$False
    Get-ADUser -Identity $User.sAMAccountName | Remove-ADObject -Recursive  -Confirm:$False
  }