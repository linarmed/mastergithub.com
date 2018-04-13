param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('5', '6','10','11', '12', '13', '14', '15', '16', '17', '20', '21', '*')] 
    [string]
    $PoolNumber
)

$tenantTypeCountMap = @{
    '5' = 9
    '6' = 9
    '10' = 9
    '11' = 9
    '12' = 9
    '13' = 9
    '14' = 9
    '15' = 9
    '16' = 9
    '17' = 9
    '20' = 5
    '21' = 5
}

if ($PoolNumber -eq '*')
{
    $poolsToCheck = $tenantTypeCountMap.Keys
}
else
{
    $poolsToCheck = @($PoolNumber)
}


foreach ($poolNumber in $poolsToCheck)
{
    "$poolNumber"
    '==========='

    foreach ($i in 0..($tenantTypeCountMap[$PoolNumber] - 1))
    {
        $tenantWildcard = "P$poolNumber`T$i`I*"
        $sipAddressWildcard = "*@P$poolNumber`T$i`I*"
    
        $tenants = (Get-CsTenant -Filter {DisplayName -like $tenantWildcard}).Count
        $users = (Get-CsUser -Filter {SipAddress -like $sipAddressWildcard}).Count

        "wildcard: $tenantWildcard; tenants: $tenants; users: $users"
    }

    "`n"
}
