$colObj = @()
$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$OldDate = [DateTime]::Today.AddDays(-30)

$Apps = Get-AzureADApplication -All $true | select appID,DisplayName,ObjectId

Foreach ($App in $Apps) 
  {
    $AppIDWrite = $App.AppId
    $AppID = $App.AppId
    $AppObjectID = $App.ObjectId
    $AppName = $App.DisplayName
    $AppID = $AppID.Insert(0,"'")
    $AppID += "'"
    
    #This portion checks if any results are returned.
    if (Get-AzureADAuditSignInLogs -Filter "appId eq $AppID") {
          $Result = 'Application in Use'
      } else {
          $Result = 'Application not used'
      }
            
      $obj = New-Object System.Object
                    $obj | Add-Member -type NoteProperty -name AppId -Value $AppIDWrite
                    $obj | Add-Member -type NoteProperty -name AppDisplayName -Value $AppName
                    $obj | Add-Member -type NoteProperty -name ObjectID -Value $AppObjectID
                    $obj | Add-Member -type NoteProperty -name Status -Value $Result
                    $colObj += $obj
  }

$colObj | export-csv '.\ApplicationStatus.csv' -NoTypeInformation -Encoding "unicode" -Delimiter "`t" -ErrorAction SilentlyContinue