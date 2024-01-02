$GPOs = Import-Csv '.\GPOs.csv'

Foreach ($GPO in $GPOs)
  {
    $GPO.GPO_ID
    $GPOGuid = $GPO.GPO_ID
    Get-GPO -Guid $GPOGuid
    #Get-GPO -Guid $GPOGuid | Remove-GPO -Confirm:$False
  }