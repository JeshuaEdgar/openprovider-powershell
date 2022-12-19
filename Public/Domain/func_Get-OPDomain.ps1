function Get-OPDomain {
    param (
        [string]$Domain
    )
    #variables for both requests
    $limit = 500

    if ($Domain) {
        $domain_request_body = @{
            limit     = $limit
            full_name = $Domain
        }
        try {
            $ErrorActionPreference = 'Stop'
            $domains = (Invoke-OPRequest -Method Get -Endpoint "domains" -Body $domain_request_body).data.results
        }
        catch {
            Write-Error $_.Exception
            return
        }
    }
    
    else {
        $domains = @()
        $offset = 0
        $total_domains = (Invoke-OPRequest -Method Get -Endpoint "domains").data.total
        try {
            do {
                $domain_request_body = @{
                    limit  = $limit
                    offset = $offset
                }
                $domains += (Invoke-OPRequest -Method Get -Endpoint "domains" -Body $domain_request_body).data.results
                $offset += 500
            } until (
                $offset -ge $total_domains
            )
        }
        catch {
            Write-Error $_.Exception.Message
        }    
    }
    
    #Return object, sort clutter from domains
    if ($domains.Count -ge 1) {
        $return_object = @()
        $i = 0
        foreach ($item in $domains) {
            $domain_object = @{
                Domain         = ($domains[$i].domain.name, $domains[$i].domain.extension) -join "."
                ID             = $domains[$i].id
                ExpirationDate = $domains[$i].expiration_date
                Sectigo        = $domains[$i].is_sectigo_dns_enabled
            }
            $return_object += $domain_object
            $i++
        }
        return $return_object
    }
    else {
        Write-Warning "Not able to find any domains with $Domain as search query"
    }
}