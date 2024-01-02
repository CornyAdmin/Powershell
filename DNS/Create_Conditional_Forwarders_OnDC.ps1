$Records = Import-Csv C:\Scripts\DNS\NewDNS.csv
$ComputerName = "<ServerName>"
#$Forwarder = "168.63.129.16" #Within Azure
$Forwarder = "<IP>"

ForEach ($Record in $Records)
  {
    $Zone = $Record.FQDN
    #$Forwarder = $Record.Forwarder
   
    Add-DnsServerConditionalForwarderZone -Name $Zone -MasterServers $Forwarder -ComputerName $ComputerName
  
  }