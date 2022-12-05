function Remove-OPZone {
    param (
        [parameter(Mandatory = $true)]
        [string]$Domain,

        [parameter(Mandatory = $true)]
        [int]$ZoneID,

        [Parameter(Mandatory = $true)]
        [ValidateSet("OpenProvider", "Sectigo")]
        [string]$Provider
    )
    $request_body = @{
        id       = $ZoneID
        provider = $Provider
    }
    try {
        $request = Invoke-OPRequest -Method Delete -Endpoint "dns/zones/$Domain" -Body $request_body
        if ($request.success -eq $true) {
            return $true
        }
    }
    catch {
        $_.Exception.Message
    }
}