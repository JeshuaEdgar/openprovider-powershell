<#
.SYNOPSIS
    Add a record to the Zone ID specified
.DESCRIPTION
    Add a record to the Zone ID specified, when none is specified it will search for the Zone ID.
.EXAMPLE
    Add-OPZoneRecord -Domain "testdomain.com" -ZoneID "12345678" -Type TXT -Value "v=SPF1 -all"
#>

function Add-OPTXTRecord {
    param (
        [parameter(Mandatory = $true)]
        [string]$Domain,
        [string]$ZoneID,
        [parameter(Mandatory = $true)]
        [string]$Value,
        [ValidateSet("A","AAAA","CAA","CNAME","MX","TXT","NS")]
        [parameter(Mandatory = $true)]
        [switch]$Type,
        [ValidateSet(900,3600,10800,21600,43200,86400)] #15m, 1h, 3h, 6h, 12h, 1day
        [int]$TTL,
        [int]$Priority
    )
    if ([string]::IsNullOrEmpty(($ZoneID))) {
        $ErrorActionPreference = "Stop"
        try {
            #try openprovider first
            $ZoneID = Get-OPZoneID -Domain $Domain -OpenProvider
        }
        catch {
            try {
                $ZoneID = Get-OPZoneID -Domain $Domain -Sectigo
            }
            catch {
                # {1:<#Do this if a terminating exception happens#>}
            }
        }
    }

    $request_body = [ordered]@{
        id = $ZoneID
        name = $Domain
        records = @{
            add = @(@{
                ttl = $TTL
                type = $Type
                value = $Value
            }
            )
        }
    } | ConvertTo-Json -Depth 3

    try {
        if ((Invoke-WebRequest -Method Put -Uri "http://api.openprovider.eu/v1beta/dns/zones/$($Domain)" -Authentication Bearer -Token $op_auth_token -Body $request_body).StatusCode -eq 200) {
            return $true
        }
    }
    catch {
        Write-Error "Failed to create TXT record for domain $Domain"
    }
}