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
        [string]$ZoneID,

        [parameter(Mandatory = $true)]
        [string]$Domain
    )
    $request_body = @{
        zone_id = $ZoneID
    }
    try {
        return (Invoke-OPRequest -Method Get "dns/zones/$($Domain)/records" -Body $request_body).data.results | Select-Object name, prio, ttl, type, value
    }
    catch {
        Write-Error "Cannot find records for domain $Domain"
    }
}