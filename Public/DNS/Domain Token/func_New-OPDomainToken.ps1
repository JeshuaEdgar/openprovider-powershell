function New-OPDomainToken {
    param(
        [string]$Domain,

        [ValidateSet("OpenProvider", "Sectigo")]
        [string]$ZoneProvider
    )

    $request_body = @{
        domain        = $Domain
        zone_provider = $ZoneProvider
    }

    Invoke-OPRequest -Method Post -Endpoint "dns/domain-token" -Body $request_body
    
}