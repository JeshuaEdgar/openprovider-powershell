function Get-OPDomainAvailability {
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
                domain        = $domain.domain
                status        = $domain.status
                currency      = $domain.price.reseller.currency
                price         = [single]$domain.price.reseller.price
                premium       = $domain.is_premium
                premium_price = [single]$domain.premium.price.create
            }
            # if ($domain.is_premium -eq $true) {
            #     $domain_data | Add-Member -NotePropertyMembers @{premium = $domain.is_premium }
            #     $domain_data | Add-Member -NotePropertyMembers @{premium_price = $domain.premium.price.create }
            # }

            $return_object += $domain_data
        }
        return $return_object
    }
    catch {
        Write-Error $_.Exception.Message
    }
}