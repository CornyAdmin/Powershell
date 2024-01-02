Import-Module ActiveDirectory
$FileName = ".\NewSubnets.csv"
$Subnets = import-csv $FileName

ForEach ($Subnet in $Subnets)
  {
    $Snet = $Subnet.subnet
    $Site = $Subnet.site
    $Location = $Subnet.Location
    $Description = $Subnet.Description
    $OUDN = $OU.DistinguishedName
    Write-Host "Creating Subnet: " $Snet
    New-ADReplicationSubnet -Name $Snet -Site $Site -Location $Location -Description $Description
  }