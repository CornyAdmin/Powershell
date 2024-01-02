$ColObj = @()
$DCs = Get-ADDomainController -filter * | select name
$FileName = ".\DNSForwarders.csv"

Foreach ($DC in $DCs)
  {
    $DCName = $DC.Name
    $DNSForwarders = (Get-DnsServerForwarder -ComputerName $DCName).IPAddress
    foreach ($DNSForwarder in $DNSForwarders)
      {
        $DNSForwarderIP = $DNSForwarder.IPAddressToString
        
        $ADObj = New-Object PSObject
        $ADObj | Add-Member NoteProperty -Name "DC_Name" -value $DCName
        $ADObj | Add-Member NoteProperty -Name "DNSForwarderIP" -value $DNSForwarderIP
        $ColObj += $ADObj
      }
  }
  
$ColObj | export-Csv $FileName -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue
