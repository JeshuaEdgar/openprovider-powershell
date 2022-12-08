<#
.SYNOPSIS
    Add a record to the Zone ID specified
.DESCRIPTION
    Add a record to the Zone ID specified, when none is specified it will search for the Zone ID.
.EXAMPLE
    Add-OPZoneRecord -Domain "testdomain.com" -ZoneID "12345678" -Type TXT -Value "v=SPF1"
#>

function Add-OPZoneRecord {
    param (
        [parameter(Mandatory = $true)]
        [string]$Domain,

        [string]$ZoneID,

        [string]$Name,

        [parameter(Mandatory = $true)]
        [string]$Value,

        [ValidateSet("A", "AAAA", "CAA", "CNAME", "MX", "TXT", "NS")]
        [parameter(Mandatory = $true)]
        [string]$Type,

        [ValidateSet(900, 3600, 10800, 21600, 43200, 86400)] #15m, 1h, 3h, 6h, 12h, 1day
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
                Write-Error "Zone ID was not found for domain $Domain, please provide valid ZoneID"
                return $false
            }
        }
    }

    # if TTL is not given, set to 1hour by default
    if (!$TTL) {
        $TTL = 3600
    }

    #build the required record body
    $request_body = [ordered]@{
        id      = $ZoneID
        name    = $Domain
        records = @{
            add = @(
                @{
                    ttl   = $TTL
                    type  = $Type
                    value = $Value
                }
            )
        }
    }

    # add priority for mx records
    if ($Type -eq "MX") {
        if (!$Priority) {
            Write-Error "Please set the priority for the $Type record"
            return
        }
        $request_body.records.add += @{prio = $Priority }
    }
    if ($Name) {
        $request_body.records.add += @{name = $Name }
    }

    #compile request body into JSON for the request
    $request_body = $request_body | ConvertTo-Json -Depth 3
    try {
        if ((Invoke-OPRequest -Method Put -Uri "dns/zones/$($Domain)" -Body $request_body).StatusCode -eq 200) {
            return $true
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
}