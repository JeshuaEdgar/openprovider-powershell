function New-OPDomainToken {
    [CmdletBinding()]
    param(
        [parameter(Position = 0)]
        [string]$Domain,

        [ValidateSet("openprovider", "sectigo")]
        [string]$ZoneProvider
    )
    
    $request_body = @{
        domain        = $Domain
        zone_provider = $ZoneProvider
    }
    try {
        $request = Invoke-OPRequest -Method Post -Endpoint "dns/domain-token" -Body $request_body
        $return_object = [PSCustomObject]@{
            Token = $request.data.token
            URL   = $request.data.url
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
    return $return_object
}