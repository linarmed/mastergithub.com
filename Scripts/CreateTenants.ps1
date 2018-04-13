param(
    [Parameter(Mandatory=$true)]
    [string]
    $PoolName,

    [Parameter(Mandatory=$true)]
    [ValidateSet("4","8","16")] 
    [string]
    $PoolSize,

    [Parameter(Mandatory=$true)]
    [string]
    $TenantPrefix,

    [Parameter(Mandatory=$false)]
    [int]
    $TypeOfTenants = -1
)

$tenantUserCounts = @()
$tenantCounts = @()

switch ($PoolSize)
{
	"16"
	{
        $tenantCounts += 20000
        $tenantUserCounts += 1

        $tenantCounts += 3500
        $tenantUserCounts += 2

        $tenantCounts += 4000
        $tenantUserCounts += 5

        $tenantCounts += 3000
        $tenantUserCounts += 20

        $tenantCounts += 800
        $tenantUserCounts += 50

        $tenantCounts += 400
        $tenantUserCounts += 100

        $tenantCounts += 70
        $tenantUserCounts += 1000

        $tenantCounts += 12
        $tenantUserCounts += 5000

        $tenantCounts += 4
        $tenantUserCounts += 10000
	}

	"8"
	{
        $tenantCounts += 166
        $tenantUserCounts += 60

        $tenantCounts += 50
        $tenantUserCounts += 100

        $tenantCounts += 18
        $tenantUserCounts += 800

        $tenantCounts += 3
        $tenantUserCounts += 5000

        $tenantCounts += 1
        $tenantUserCounts += 10000
	}

	"4"
	{
        $tenantCounts += 5000
        $tenantUserCounts += 1

        $tenantCounts += 875
        $tenantUserCounts += 2

        $tenantCounts += 1000
        $tenantUserCounts += 5

        $tenantCounts += 750
        $tenantUserCounts += 20

        $tenantCounts += 200
        $tenantUserCounts += 50

        $tenantCounts += 100
        $tenantUserCounts += 100

        $tenantCounts += 17
        $tenantUserCounts += 1000

        $tenantCounts += 3
        $tenantUserCounts += 5000

        $tenantCounts += 1
        $tenantUserCounts += 10000
	}
}

$totalTenants = 0
$totalUsers = 0

$tenantNameFormatPrefix = "T{0}I"
$tenantNameFormat = $tenantNameFormatPrefix + "{1}.com"

$startTime = [DateTime]::Now
echo $startTime
echo "Creating Tenants"

for ($i=0; $i -lt $tenantCounts.Length; $i++)
{
    $tenantCount = $tenantCounts[$i]

    if ($TypeOfTenants -ne -1 -and $TypeOfTenants -ne $i)
    {
        "Skipping $tenantCount..."
        continue
    }

    $userCount = $tenantUserCounts[$i]
    $tenantNamePrefix = ($TenantPrefix + ($tenantNameFormatPrefix -f $i))

    $totalTenants += $tenantCount
    $totalUsers += ($tenantCount * $userCount)

    <# UserManager's SuffixEnd parameters are inclusive, so we decrement #>
    $tenantCount--
    $userCount--

    $userManagerParameters = "/CreateTenant /TenantPrefix $tenantNamePrefix /TenantPostfix .com /TenantSuffixStart 0 /TenantSuffixEnd $tenantCount /userprefix u /usersuffixstart 0 /usersuffixend $userCount /password 07Apples /hostingprovider SRV: /ClusterFQDN $PoolName"
    Invoke-Expression ".\UserManager.exe $userManagerParameters"
}

echo ""
$endTime = [DateTime]::Now
echo ("Duration: " + ($endTime - $startTime).ToString())
echo "User Creation Finished:"
echo ("Total Tenants Created: {0}" -f $totalTenants)
echo ("Total Users Created: {0}" -f $totalUsers)
echo ""

echo "Pool Endpoint Declarations:"
for ($i=0; $i -lt $tenantCounts.Length; $i++)
{
    $tenantCount = $tenantCounts[$i]
    $userCount = $tenantUserCounts[$i]
    $domainFormat = ($TenantPrefix + ($tenantNameFormat -f $i, "{0}"))

    echo ("UserNameFormat: u{0}")
    echo ("UserCount: {0}" -f $userCount)
    echo ("DomainFormat: {0}" -f $domainFormat)
    echo ("DomainCount: {0}" -f $tenantCount)
    echo ""
}
