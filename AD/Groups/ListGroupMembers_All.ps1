import-module ActiveDirectory
$ColObj = @()

$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$Sevendays = (Get-Date).AddDays(-7).ToString('yyyy-MM-dd')
$FirstMatch = "01.csv"

$ExportFile = ".\GroupMembers_" + $CurrentDate + ".csv"
$DelOldReport = ".\GroupMembers_" + $Sevendays + ".csv"

$OUs = cat '.\OrgOUs.txt'
$root = (Get-ADDomain).DistinguishedName

ForEach ($OU in $OUs) 
  {
		$OUSearch = $OU + $root
    $AllSG = get-adgroup -Filter * -SearchBase $OUSearch -Properties * | select Name, DistinguishedName, ManagedBy, description, GroupCategory, groupScope, groupType

      Foreach ($SG in $allSg) 
        {
          #Write-Host $SG
          $Members = Get-ADGroup $SG.DistinguishedName -Properties Member | Select-Object -ExpandProperty Member
        
          $Total = $Members.Count
          #Write-Host "Members:" $Total
    
          Foreach ($member in $members) 
            {
              $Obj = New-Object PSObject
              If ($member -ilike "<Condition1>") 
                {
                  $addDetails = $member | Get-ADObject -Properties * | select distinguishedName, name, objectclass, SamAccountName, mail
                  $Obj | Add-Member NoteProperty -Name "SamAccountName" -Value $addDetails.SamAccountName
                  $Obj | Add-Member NoteProperty -Name "DisplayName" -Value $addDetails.Name
                  $Obj | Add-Member NoteProperty -Name "ObjectClass" -Value $addDetails.ObjectClass
                  $Obj | Add-Member NoteProperty -Name "distinguishedName" -Value $addDetails.distinguishedName
                  $Obj | Add-Member NoteProperty -Name "Mail" -Value $addDetails.mail
                  $Obj | Add-Member NoteProperty -Name "Group Name" -Value $SG.name
                  $Obj | Add-Member NoteProperty -Name "Group DN" -Value $SG.distinguishedName
                  $Obj | Add-Member NoteProperty -Name "Group Category" -Value $SG.GroupCategory
                  $Obj | Add-Member NoteProperty -Name "Group Owner" -Value $SG.ManagedBy
                  $Obj | Add-Member NoteProperty -Name "Group Scope" -Value $SG.groupScope
                  $Obj | Add-Member NoteProperty -Name "Group Type" -Value $SG.groupType
                  $Obj | Add-Member NoteProperty -Name "Group description" -Value $SG.description
                  $ColObj += $obj
                }
              elseif ($member -ilike "<Condition2>") 
                {
                  $addDetails = $member | Get-ADObject -Properties * | select distinguishedName, name, objectclass, SamAccountName
                  $Obj | Add-Member NoteProperty -Name "SamAccountName" -Value $addDetails.SamAccountName
                  $Obj | Add-Member NoteProperty -Name "DisplayName" -Value $addDetails.Name
                  $Obj | Add-Member NoteProperty -Name "ObjectClass" -Value $addDetails.ObjectClass
                  $Obj | Add-Member NoteProperty -Name "distinguishedName" -Value $addDetails.distinguishedName
                  $Obj | Add-Member NoteProperty -Name "Mail" -Value $addDetails.mail
                  $Obj | Add-Member NoteProperty -Name "Group Name" -Value $SG.name
                  $Obj | Add-Member NoteProperty -Name "Group DN" -Value $SG.distinguishedName
                  $Obj | Add-Member NoteProperty -Name "Group Category" -Value $SG.GroupCategory
                  $Obj | Add-Member NoteProperty -Name "Group Owner" -Value $SG.ManagedBy
                  $Obj | Add-Member NoteProperty -Name "Group Scope" -Value $SG.groupScope
                  $Obj | Add-Member NoteProperty -Name "Group Type" -Value $SG.groupType
                  $Obj | Add-Member NoteProperty -Name "Group description" -Value $SG.description
                  $ColObj += $obj
                }
            }
    
        }
  }  
$ColObj | export-Csv $ExportFile -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue

#If (-not($DelOldReport -match $FirstMatch))
#	{
#		Del $DelOldReport
#	}