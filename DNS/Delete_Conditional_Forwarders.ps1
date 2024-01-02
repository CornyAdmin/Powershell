$Records = Import-Csv ".\Remove_DNS_recordset.csv"
$ComputerName = "<ServerName>"

ForEach ($Record in $Records) {
   $Zone = $Record.FQDN
   Remove-DnsServerZone -Name $Zone -ComputerName $ComputerName -Confirm:$False
  }