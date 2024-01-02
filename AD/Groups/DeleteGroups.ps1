$Groups = Import-Csv '.\GroupList.csv'

Foreach ($Group in $Groups)
  {
    $Group.GroupDN
    #Get-ADGroup -Identity $Group.GroupDN
    Get-ADGroup -Identity $Group.GroupDN | Remove-ADGroup -Confirm:$False
    #Get-ADGroup -Identity $Group.GroupDN | Remove-ADObject -Recursive  -Confirm:$False
  }