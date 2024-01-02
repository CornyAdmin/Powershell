$FileName = ".\DNSZones.csv"
$AllZones = Get-DnsServerZone -ComputerName <ServerName>

$AllZones | export-Csv $FileName -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue
