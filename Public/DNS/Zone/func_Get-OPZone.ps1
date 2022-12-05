function Get-OPZone {
    param (
        [string]$Domain
    )
    $limit = 500
    if ($Domain) {
        #We have to split the domain to search for the domain, filtering is done afterwards
        $domain_name_pattern = $Domain.Split(".")[0]
        $request_body = @{
            name_pattern = $domain_name_pattern
        }
        try {
            $request = Invoke-OPRequest -Method Get -Endpoint "dns/zones" -Body $request_body
            $zones = $request.data.results | Where-Object { $_.name -eq $Domain }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    #all domains
    else {
        try {
            $total = (Invoke-OPRequest -Method Get -Endpoint "dns/zones" -Body $request_body).data.total
            if ($total -gt 100) {
                $zones = @()
                $offset = 0
                do {
                    $request_body = @{
                        limit  = $limit
                        offset = $offset
                    }
                    $zones += (Invoke-OPRequest -Method Get -Endpoint "dns/zones" -Body $request_body).data.results
                    $offset += 500
                } until (
                    $offset -ge $total
                )
            }
            else {
                $zones = (Invoke-OPRequest -Method Get -Endpoint "dns/zones" -Body $request_body).data.results
            }
	
        }
        catch {
            Write-Error $_.Exception.Message
        }    
    }
    if (($Domain) -and ([string]::IsNullOrEmpty($zones))) {
        Write-Warning "No zones found for domain $Domain"
    }
    return $zones
}

