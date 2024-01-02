$colDCs = @() 
$FileName = ".\DC_Details.csv"
$allDCs = (Get-ADForest).Domains | %{ Get-ADDomainController -Filter * -Server $_ }

#ForEach ($DC in $allDCs)
#  {
#    $Dom = $DC.Domain
#    $NTDSSet = $DC.NTDSSettingsObjectDN
#  }
  
$allDCs | export-csv $FileName -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue