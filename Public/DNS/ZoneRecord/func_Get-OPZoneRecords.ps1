<#
.SYNOPSIS
    Get the Zone record(s) for a domain
.DESCRIPTION
    Get the Zone record(s) for a domain, use a Zone ID with your request
.EXAMPLE
    Get-OPZoneRecord -ZoneID "12345678" -Domain "testdomain.com"
#>

function Get-OPZoneRecords {
    param (
        [parameter(Mandatory = $true)]
        [string]$Domain,

        [parameter(Mandatory = $true)]
        [string]$ZoneID
    )
    $request_body = @{
        zone_id = $ZoneID
    }
    try {
        $request = (Invoke-OPRequest -Method Get "dns/zones/$($Domain)/records" -Body $request_body).data.results
        
        $return_object = @()
        $request | ForEach-Object {
            $return_object += [PSCustomObject]@{
                Name     = $_.name
                Priority = $_.prio
                TTL      = $_.ttl
                Type     = $_.type
                Value    = $_.value
            }
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
    return $return_object
}