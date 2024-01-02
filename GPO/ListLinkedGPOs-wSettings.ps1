Import-Module activedirectory
$OUs = @()
$GPOLinks = @()
$colObj = @()


$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$ExportFile = ".\GPO_Linked_Extract_" + $CurrentDate + ".csv"

#Query AD
$Dom = Get-ADDomain | Select DistinguishedName
$OUs += $Dom
$OULists = Get-ADOrganizationalUnit -filter * -Properties * | Select DistinguishedName
$OUs += $OULists
$OUs

ForEach ($OU in $OUs)
  {
    $OUDN = $OU.DistinguishedName
    $OUDN
    If ($OUDN -eq $Dom.DistinguishedName)
      {
        $GPOLinksRoot = Get-ADDomain | select -ExpandProperty LinkedGroupPolicyObjects
        Write-Host "Domain GPOs"
        $GPOLinks += $GPOLinksRoot
      }
    else
      {
        $GPOLinksOU = Get-ADOrganizationalUnit $OUDN -Properties LinkedGroupPolicyObjects | select -ExpandProperty LinkedGroupPolicyObjects
        $GPOLinks += $GPOLinksOU
      }
      
    ForEach ($GPOLink in $GPOLinks)
      {
        $obj = New-Object System.Object
        $GPOName = ([adsi]"LDAP://$GPOLink").name
        $GPOName = $GPOName.replace("{","")
        $GPOName = $GPOName.replace("}","")
        $GPOName
        $GPODetails = Get-GPO -id $GPOName | Select DisplayName,DomainName,Id,GpoStatus,CreationTime,ModificationTime
        $GPOExtract = $GPODetails.DisplayName
        $Path = ".\" + $GPOExtract + ".html"
        Get-GPOReport -Name $GPOExtract -ReportType HTML -Path $Path
        
        $obj | Add-Member -type NoteProperty -name 'Organizational Unit' -Value $OUDN
        $obj | Add-Member -type NoteProperty -name 'GPO Name' -Value $GPODetails.DisplayName
        $obj | Add-Member -type NoteProperty -name 'GPO ID' -Value $GPODetails.Id
        $obj | Add-Member -type NoteProperty -name 'GPO Status' -Value $GPODetails.GpoStatus
        $obj | Add-Member -type NoteProperty -name 'GPO Created' -Value $GPODetails.CreationTime
        $obj | Add-Member -type NoteProperty -name 'GPO Modified' -Value $GPODetails.ModificationTime
        $colObj += $obj
      }
     $GPOLinks = @()
   }
   
$colObj | export-csv $ExportFile -NoTypeInformation -Encoding "unicode" -Delimiter "`t" -ErrorAction SilentlyContinue
   