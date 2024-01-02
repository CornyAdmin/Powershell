$AZUSers = Import-Csv '.\GroupMembers.csv'

ForEach ($AZUSer in $AZUSers)
  {
    $AZUSer.GroupName
    $AZUSer.sAMAccountName
    $Group = get-adgroup -identity $AZUSer.GroupName
    $User = get-aduser $AZUSer.sAMAccountName
    $GroupDN = $Group.DistinguishedName
    $UserDN = $User.DistinguishedName
    Add-ADGroupMember -Identity $GroupDN -Members $UserDN
  }
