Import-Module activedirectory
$colObj = @()

$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$ExportFile = ".\GPO_Extract_" + $CurrentDate + ".csv"

#Single OU:
#$OUs = Get-ADOrganizationalUnit '<OUName>' -Properties * | Select DistinguishedName,CanonicalName

#Query AD
$OUs = Get-ADOrganizationalUnit -filter * -Properties * | Select DistinguishedName,CanonicalName

ForEach ($OU in $OUs)
  {
    $OUDN = $OU.DistinguishedName
    $OUDN
    $OUCN = $OU.CanonicalName
    $GPOLinks = Get-ADOrganizationalUnit $OUDN -Properties LinkedGroupPolicyObjects | select -ExpandProperty LinkedGroupPolicyObjects
    ForEach ($GPOLink in $GPOLinks)
      {
        $obj = New-Object System.Object
        $GPOName = ([adsi]"LDAP://$GPOLink").name
        $GPOName = $GPOName.replace("{","")
        $GPOName = $GPOName.replace("}","")
        $GPOName
        $GPODetails = Get-GPO -id $GPOName | Select DisplayName,DomainName,Id,GpoStatus,CreationTime,ModificationTime
        
        
        $obj | Add-Member -type NoteProperty -name 'Organizational Unit' -Value $OUDN
        $obj | Add-Member -type NoteProperty -name 'GPO Name' -Value $GPODetails.DisplayName
        $obj | Add-Member -type NoteProperty -name 'GPO ID' -Value $GPODetails.Id
        $obj | Add-Member -type NoteProperty -name 'GPO Status' -Value $GPODetails.GpoStatus
        $obj | Add-Member -type NoteProperty -name 'GPO Created' -Value $GPODetails.CreationTime
        $obj | Add-Member -type NoteProperty -name 'GPO Modified' -Value $GPODetails.ModificationTime
        $colObj += $obj
      }
   }
   
$colObj | export-csv $ExportFile -NoTypeInformation -Encoding "unicode" -Delimiter "`t" -ErrorAction SilentlyContinue
   