$colObj = @()

$GroupM5 = "<GroupID>"
$GroupF1 = "<GroupID>"
$GroupE1 = "<GroupID>"
$GroupE5 = "<GroupID>"

$GroupM5Disp = (Get-MsolGroup -ObjectId $GroupM5).displayName
$GroupF1Disp = (Get-MsolGroup -ObjectId $GroupF1).displayName
$GroupE1Disp = (Get-MsolGroup -ObjectId $GroupE1).displayName
$GroupE5Disp = (Get-MsolGroup -ObjectId $GroupE5).displayName

$DefaultDisp = "False"

$LicenseExtracts = Get-MsolUser -all | where {$_.IsLicensed -eq "True" } |select UserPrincipalName,objectID,IsLicensed -ExpandProperty Licenses



foreach ($LicenseExtract in $LicenseExtracts)
	{
        $GroupName = ""
        $Assigned = ""
        $obj = New-Object System.Object
        $UPN = $LicenseExtract.UserPrincipalName
        $UPN
        $AccountSkuId = $LicenseExtract.AccountSkuId
        $AccountSkuId
        $UserLic = $LicenseExtract.objectID
        Foreach ($groupLic in $LicenseExtract.GroupsAssigningLicense)
          {
            #Write-Host "Assignment:" $groupLic

            switch ( $groupLic )
              {
                $GroupM5 {
                  $GroupName = $GroupM5Disp
                  $Assigned = "False"
                  }
                $GroupF1 {
                  $GroupName = $GroupF1Disp
                  $Assigned = "False"
                  }
                $GroupE1 {
                  $GroupName = $GroupE1Disp
                  $Assigned = "False"
                  }
                $GroupE5 {
                  $GroupName = $GroupE5Disp
                  $Assigned = "False"
                  }
                $UserLic {
                  $Assigned = "True"
                  $GroupName = "False"
                  }
                #default {$GroupName = $DefaultDisp}
              }
              
          }
        
        #If ($Assigned -ne "True") {$Assigned = "False"}   
        #If ($GroupName -eq "") {$GroupName = "False"}
        $GroupName
        $Assigned
        #Write-Host "ObjectID" $LicenseExtract.objectID
        
    
    $obj = New-Object System.Object

    $obj | Add-Member -type NoteProperty -name UserPrincipalName -Value $UPN
    $obj | Add-Member -type NoteProperty -name AccountSkuId -Value $AccountSkuId
    $obj | Add-Member -type NoteProperty -name Directly_Assigned -Value $Assigned
    $obj | Add-Member -type NoteProperty -name Group_Assigned -Value $GroupName
    $colObj += $obj
	}

#$colObj
$colObj | export-csv '.\LicensedUsers_O365_test.csv' -NoTypeInformation -Encoding "unicode" -Delimiter "`t" -ErrorAction SilentlyContinue