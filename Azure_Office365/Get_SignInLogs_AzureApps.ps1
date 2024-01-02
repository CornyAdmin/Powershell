$colObj = @()
$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$OldDate = [DateTime]::Today.AddDays(-7)
$CurrentDate
$OldDate

$Apps = import-csv $Output -Delimiter "`t"

Foreach ($App in $Apps) 
  {
    $AppID = $App.AppId
    $AppName = $App.DisplayName
    $AppID = $AppID.Insert(0,"'")
    $AppID += "'"

    $Logs = Get-AzureADAuditSignInLogs -Filter "Mail eq $AppID" | Select AppId, AppDisplayName, UserPrincipalName, CreatedDateTime
    
    $obj = New-Object System.Object
                    $obj | Add-Member -type NoteProperty -name AppId -Value $CurUser
                    $obj | Add-Member -type NoteProperty -name AppDisplayName -Value $Current.FNAME
                    $obj | Add-Member -type NoteProperty -name UserPrincipalName -Value $Current.LNAME
                    $obj | Add-Member -type NoteProperty -name CreatedDateTime -Value $Current.EMAIL
                    $obj | Add-Member -type NoteProperty -name Name -Value $Name
                    $colObj += $obj
  }