<#
.SYNOPSIS
    Add a TXT record to the Zone ID specified
.DESCRIPTION
    Add a TXT record to the Zone ID specified, when none is specified it will search for the Zone ID.
.EXAMPLE
    Add-OPTXTRecord -Domain "testdomain.com" -ZoneID "12345678" -Value "v=SPF1 -all"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>

function Add-OPTXTRecord {
    param (
        [parameter(Mandatory = $true)]
        [string]$Domain,
        [string]$ZoneID,
        [parameter(Mandatory = $true)]
        [string]$Value
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
                ttl = 900
                type = "TXT"
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
        return $false
    }
}