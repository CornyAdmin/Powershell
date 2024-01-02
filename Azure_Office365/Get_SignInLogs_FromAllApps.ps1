$colObj = @()
$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$OldDate = [DateTime]::Today.AddDays(-7)
$CurrentDate
$OldDate

$Apps = Get-AzureADApplication -All $true | select appID,DisplayName

Foreach ($App in $Apps) 
  {
    $AppID = $App.AppId
    $AppName = $App.DisplayName
    $AppID = $AppID.Insert(0,"'")
    $AppID += "'"

    if (Get-AzureADAuditSignInLogs -Filter "appId eq $AppID")
    
    Foreach ($Log in $Logs) 
      {
        $obj = New-Object System.Object
                    $obj | Add-Member -type NoteProperty -name AppId -Value $Log.AppId
                    $obj | Add-Member -type NoteProperty -name AppDisplayName -Value $Log.AppDisplayName
                    $obj | Add-Member -type NoteProperty -name UserPrincipalName -Value $Log.UserPrincipalName
                    $obj | Add-Member -type NoteProperty -name CreatedDateTime -Value $Log.CreatedDateTime
                    $colObj += $obj
      }
  }
  
if ( $x = get-adgroup -filter {name -like $nameentered} ) {
     $x
} else {
     Write-Host 'nothing found'
}