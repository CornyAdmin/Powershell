Import-Module ActiveDirectory

$ComputerCollection = @()

$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$Sevendays = (Get-Date).AddDays(-7).ToString('yyyy-MM-dd')

$ExportFile = ".\ComputerExtract_" + $CurrentDate + ".csv"
$DelOldReport = ".\ComputerExtract_" + $Sevendays + ".csv"

$OUs = cat D:\Extracts\OrgOUs_AF_Computers.txt
$root = (Get-ADDomain).DistinguishedName

ForEach ($OU in $OUs)
	{
		$OUSearch = $OU + $root
		$OULevels = Get-ADOrganizationalUnit -Filter * -SearchScope subtree -SearchBase $OUSearch | select DistinguishedName
		ForEach ($OULevel in $OULevels)
			{
				$OULevel
				$Extract = Get-ADComputer -LDAPFilter "(objectclass=computer)" -SearchScope oneLevel -SearchBase $OULevel.DistinguishedName -properties * | select Name,ipv4address,Enabled,created,ManagedBy,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion,DistinguishedName,@{Name="lastLogonTimeStamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}},@{Name="pwdLastSet"; Expression={[DateTime]::FromFileTime($_.pwdLastSet)}}
				$ComputerCollection += $Extract
			}
	}
$ComputerCollection | export-Csv $ExportFile -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue
Del $DelOldReport