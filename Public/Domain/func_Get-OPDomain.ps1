function Get-OPDomain {
    [CmdletBinding()]
    param (
        [string]$Domain,

        [switch]$Detailed
    )
    #variables for both requests
    $limit = 500

    if ($Domain -ne "") {
        $domain_request_body = @{
            full_name = $Domain
        }
        try {
            $domains = (Invoke-OPRequest -Method Get -Endpoint "domains" -Body $domain_request_body).data.results
        }
        catch {
            Write-Error $_.Exception.Message
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
            return
        }    
    }

    #Return object, sort clutter from domains
    if ($domains.Count -ge 1) {
        $return_object = @()
        $i = 0
        foreach ($item in $domains) {
            $domain_object = [pscustomobject]@{
                ID     = $domains[$i].id
                Domain = ($domains[$i].domain.name, $domains[$i].domain.extension) -join "."
                
            }
            if ($Detailed) {
                $domain_object | Add-Member @{
                    ResellerID      = $domains[$i].reseller_id
                    CreationDate    = [DateTime]$domains[$i].creation_date
                    ExpirationDate  = [DateTime]$domains[$i].expiration_date
                    AutoRenew       = $domains[$i].autorenew
                    RenewalDate     = [DateTime]$domains[$i].renewal_date
                    WhoIs           = $domains[$i].is_hosted_whois
                    DNSSec          = $domains[$i].is_dnssec_enabled
                    Sectigo         = $domains[$i].is_sectigo_dns_enabled
                    NameserverGroup = $domains[$i].ns_group
                }
            }
            $return_object += $domain_object
            $i++
        }
    }
    else {
        Write-Warning "Not able to find any domains with $Domain as search query"
    }
    return $return_object 
}