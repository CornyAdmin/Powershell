$Filename = ".\Groups.csv"
$Groups = import-csv $Filename
$Manager = "Name"
$Path = "<OUPath>"

$ColObj = @()

ForEach ($Group in $Groups)
  {
    $GroupName = $Group.GroupName
    $GroupName
    $GroupDescription = $Group.Description
    $GroupDescription  += "- More info"
    New-ADGroup -Name $GroupName -SamAccountName $GroupName -GroupCategory Security -GroupScope Universal -DisplayName $GroupName -Path $Path -Description $GroupDescription -ManagedBy $Manager
  }