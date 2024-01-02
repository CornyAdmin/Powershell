$members = Get-ADGroupMember "<GroupName>" | select SamAccountName

ForEach ($member in $members) 
  {
    Get-ADUser $member.SamAccountName | select UserPrincipalName
  }