function Get-OPDomainAvailability {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        $Domain
    )
    $domains_request = @()
    foreach ($i in $Domain) {
        $domains_request += @{
            name      = $i.Split(".")[0]
            extension = $i.Split(".")[1]
        }

    }
    $request_body = @{
        domains    = $domains_request
        with_price = $true
    }

    try {
        $request = Invoke-OPRequest -Method Post -Endpoint "domains/check" -Body $request_body
        $return_object = @()
        foreach ($domain in $request.data.results) {
            $domain_data = [PSCustomObject]@{
                Domain       = $domain.domain
                Status       = $domain.status
                Currency     = $domain.price.reseller.currency
                Price        = [single]$domain.price.reseller.price
                Premium      = if ($domain.is_premium -eq $true) { $true }else { $false }
                PremiumPrice = [single]$domain.premium.price.create
            }
            $return_object += $domain_data
        }
    }
    catch {
        throw $_.Exception.Message
    }
    return $return_object 
}