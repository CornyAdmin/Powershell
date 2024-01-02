Import-Module activedirectory
$colObj = @()

$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$GPOLinks = Import-csv .\AllGPOs_ID.csv
    
    ForEach ($GPOLink in $GPOLinks)
      {
        $GPOName = $GPOLink.GPO_ID
        $GPODetails = Get-GPO -id $GPOName | Select DisplayName,DomainName,Id,GpoStatus,CreationTime,ModificationTime
        $GPOExtract = $GPODetails.DisplayName
        $GPOExtract
	$GPOExtractPath = $GPOExtract
        $GPOExtractPath = $GPOExtractPath.replace("*","42")
        $GPOExtractPath = $GPOExtractPath.replace("/","47")
        $GPOExtractPath = $GPOExtractPath.replace(":","58")        
        $Path = ".\" + $GPOExtractPath + ".html"
        Get-GPOReport -Name $GPOExtract -ReportType HTML -Path $Path
      }

   