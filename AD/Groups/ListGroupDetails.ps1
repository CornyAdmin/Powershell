import-module ActiveDirectory
$ColObj = @()

$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$Sevendays = (Get-Date).AddDays(-7).ToString('yyyy-MM-dd')
$FirstMatch = "01.csv"

$ExportFile = ".\GroupDetails_" + $CurrentDate + ".csv"
$DelOldReport = ".\GroupDetails_" + $Sevendays + ".csv"

$AllSG = get-adgroup -Filter * -SearchBase "<BaseDN>" -Properties * | select Name,DistinguishedName,ManagedBy,description,GroupCategory,groupScope,groupType

Foreach($SG in $allSg)

  {
    Write-Host $SG
    $Members = Get-ADGroup $SG.DistinguishedName -Properties Member | Select-Object -ExpandProperty Member
    
    $Obj = New-Object PSObject    
    $Total = $Members.Count
    Write-Host "Members:" $Total
            
    $Obj | Add-Member NoteProperty -Name "Group Name" -Value $SG.name
    $Obj | Add-Member NoteProperty -Name "Group DN" -Value $SG.distinguishedName
    $Obj | Add-Member NoteProperty -Name "Group Member Count" -Value $Total
    $Obj | Add-Member NoteProperty -Name "Group Owner" -Value $SG.ManagedBy
    $Obj | Add-Member NoteProperty -Name "Group description" -Value $SG.description
    $Obj | Add-Member NoteProperty -Name "Group Category" -Value $SG.GroupCategory
    $Obj | Add-Member NoteProperty -Name "Group Scope" -Value $SG.groupScope
    $Obj | Add-Member NoteProperty -Name "Group Type" -Value $SG.groupType
    $ColObj += $obj
    
  }
  
$ColObj | export-Csv $ExportFile -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue
