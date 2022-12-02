function Get-OPDomain {
    param (
        [string]$Domain,
        [switch]$All
    )
    #variables for both requests
    $limit = 500

    if ($Domain) {
        $Domain = $Domain.Split(".")[0]
        $domain_request_body = @{
            limit               = $limit
            domain_name_pattern = $Domain
        }
        try {
            $ErrorActionPreference = 'Stop'
            $domains = (Invoke-OPRequest -Method Get -Endpoint "domains" -Body $domain_request_body).data.results
            # $domains = (Invoke-RestMethod -Method Get "https://api.openprovider.eu/v1beta/domains" -Authentication Bearer -Token $op_auth_token -Body $domain_request_body).data.results
        }
        catch {
            Write-Error $_.Exception
            return
        }
    }
    
    if ($All) {
        $domains = @()
        $offset = 0
        $total_domains = (Invoke-OPRequest -Method Get -Endpoint "domains").data.total
        # $total_domains = (Invoke-RestMethod -Method Get "https://api.openprovider.eu/v1beta/domains" -Authentication Bearer -Token $op_auth_token).data.total
        try {
            do {
                $domain_request_body = @{
                    limit  = $limit
                    offset = $offset
                }
                $domains += (Invoke-OPRequest -Method Get -Endpoint "domains" -Body $domain_request_body).data.results
                # $domains += (Invoke-RestMethod -Method Get "https://api.openprovider.eu/v1beta/domains" -Authentication Bearer -Token $op_auth_token -Body $domain_request_body).data.results
                $offset += 500
            } until (
                $offset -ge $total_domains
            )
        }
        catch {
            Write-Error "Something went wrong, could not find domains"
            Write-Error $Error[0].Exception
            return
        }    
    }
    return $domains
}