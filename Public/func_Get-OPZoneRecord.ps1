<#
.SYNOPSIS
    Get the Zone record(s) for a domain
.DESCRIPTION
    Get the Zone record(s) for a domain, use a Zone ID with your request
.EXAMPLE
    Get-OPZoneRecord -ZoneID "12345678" -Domain "testdomain.com"
#>

function Get-OPZoneRecord {
    param (
        [string]$ZoneID,
        [string]$Domain
    )
    $request_body = @{
        zone_id = $ZoneID
    }
    return (Invoke-RestMethod -method get "https://api.openprovider.eu/v1beta/dns/zones/$($Domain)/records" -Authentication bearer -Token $op_auth_token -Body $request_body).data.results | Select-Object name, prio, ttl, type, value
}