function Get-OPZone {
    param (
        [string]$Domain,

        [ValidateSet("openprovider", "sectigo")]
        [string]$Provider
    )
    $limit = 500
    if ($Domain) {
        try {
            $zone_splat = @{
                Method   = "Get"
                Endpoint = "dns/zones/$Domain"
            }
            if ($Provider) {
                $zone_splat.Body += @{provider = $Provider }
            }
            $zones = (Invoke-OPRequest @zone_splat).data
        }
        catch {
            Write-Error $_.Exception.Message
            return
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
                    if ($Provider) {
                        $request_body += @{provider = $Provider }
                    }
                    Write-Host "this is a test"
                    $zones += (Invoke-OPRequest -Method Get -Endpoint "dns/zones" -Body $request_body).data.results
                    $offset += 500
                } until (
                    $offset -ge $total
                )
            }
            else {
                $request_body = @{
                    limit = $limit
                }
                if ($Provider) {
                    $request_body += @{provider = $Provider }
                }
                $zones = (Invoke-OPRequest -Method Get -Endpoint "dns/zones" -Body $request_body).data.results
            }
        }
        catch {
            Write-Error $_.Exception.Message
            return
        }    
    }

    $return_object = @()
    $i = 0
    foreach ($item in $zones) {
        $zone_object = [pscustomobject]@{
            ZoneID   = $zones[$i].id
            Domain   = $zones[$i].name            
            Provider = $zones[$i].provider
            Type     = $zones[$i].type
            Active   = $zones[$i].active
        }
        $return_object += $zone_object
        $i++
    }
    return $return_object
}

