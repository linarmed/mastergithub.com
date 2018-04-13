param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("4","8","16")] 
    [string]
    $PoolSize,

    [Parameter(Mandatory=$true)]
    [string]
    $TenantPrefix
)

$tenantCountMap = @{
    "16" = 20000, 3500, 4000, 3000, 800, 400, 70, 12, 4
    "8"  = 166, 50, 18, 3, 1
    "4"  = 5000, 875, 1000, 750, 200, 100, 17, 3, 1
}

$totalTenants = 0

$tenantNameFormatPrefix = "T{0}I"
$tenantNameFormat = $tenantNameFormatPrefix + "{1}.com"

$startTime = [DateTime]::Now
echo $startTime
echo "Deleting Tenants"

$tenantCounts = $tenantCountMap[$PoolSize]

for ($i=0; $i -lt $tenantCounts.Length; $i++)
{
    $tenantCount = $tenantCounts[$i]
    $tenantNamePrefix = ($TenantPrefix + ($tenantNameFormatPrefix -f $i))

    $totalTenants += $tenantCount

    for ($tenantNumber = 0; $tenantNumber -lt $tenantCount; ++$tenantNumber)
    {
        $userManager = ".\UserManager.exe /DeleteTenant /Tenant $tenantNamePrefix$tenantNumber.com" 

        "Invoking $userManager..."

        Invoke-Expression $userManager
    }
}

echo ""
$endTime = [DateTime]::Now
echo ("Duration: " + ($endTime - $startTime).ToString())
echo "User deletetion finished:"
echo ("Total Tenants deleted: {0}" -f $totalTenants)
echo ""

