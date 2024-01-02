$ExportPath = ".\export\"
$AllZones = Get-DnsServerZone -ComputerName <ServerName> | where {$_.IsReverseLookupZone -eq $True}

ForEach ($AllZone in $AllZones)
  {
    $ZoneName = $AllZone.ZoneName
    $ZoneName
    $ZoneFile = $ZoneName.replace('.','')
    $ZoneFile
    $export = $ExportPath + $ZoneFile
    $export
    Export-DnsServerZone -Name $ZoneName -FileName $export
  }
