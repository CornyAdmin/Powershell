Import-Module ActiveDirectory

$UserCollection = @()
$k = 0
$OUs = cat .\OrgOUs.txt
$root = (Get-ADDomain).DistinguishedName

ForEach ($OU in $OUs)
	{
		
		$OUSearch = $OU + $root
		$OUSearch
		$OULevels = Get-ADOrganizationalUnit -Filter * -SearchScope subtree -SearchBase $OUSearch | select DistinguishedName
		ForEach ($OULevel in $OULevels)
			{
				$Extract = Get-ADUser -LDAPFilter "(&(objectclass=user)(objectcategory=person))" -SearchScope oneLevel -SearchBase $OULevel.DistinguishedName -properties * |
				select sAMAccountName,mail,Enabled,CanonicalName,DistinguishedName,DisplayName,givenName,SurName,ObjectGUID,Description,Title,telePhoneNumber,mobile,Office,
				Department,Company,City,co,homeMDB,targetAddress,extensionAttribute6,WhenCreated,whenChanged,msExchHideFromAddressLists,
				@{Label='Manager';Expression={(Get-ADUser $_.Manager).Name}},
				@{Label='LastLogonTimeStamp';Expression={[DateTime]::FromFileTime($_.LastLogontimestamp).ToString('g')}},
				@{Label='accountExpires';Expression={[DateTime]::FromFileTime($_.accountExpires).ToString('g')}},
				@{Label='PasswordLastSet';Expression={[DateTime]::FromFileTime($_.pwdLastSet).ToString('g')}}
				$UserCollection += $Extract
			}
		$k = $k + 1
		$FileName = ".\AF_UserExtract_" + $k + ".csv"
		$UserCollection | export-Csv $FileName -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue
		$UserCollection = $null
		$UserCollection = @()
	}
