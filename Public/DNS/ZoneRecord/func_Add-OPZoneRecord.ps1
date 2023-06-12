<#
.SYNOPSIS
    Add a record to the Zone ID specified
.DESCRIPTION
    Add a record to the Zone ID specified, when none is specified it will search for the Zone ID.
.EXAMPLE
    Add-OPZoneRecord -Domain "testdomain.com" -ZoneID "12345678" -Type TXT -Value "v=SPF1"
#>

function Add-OPZoneRecord {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$Domain,

        [parameter(Mandatory = $true)]
        [string]$ZoneID,

        [string]$Name,

        [parameter(Mandatory = $true)]
        [string]$Value,

        [ValidateScript({
                if ($_ -eq "MX" -and ($PSBoundParameters["Priority"] -is [int])) {
                    $IsValid = $true
                }
                if (-not $IsValid) {
                    throw "Please set the priority for the MX record, use a valid integer"
                }
                $true
            })]
        [ValidateSet("A", "AAAA", "CAA", "CNAME", "MX", "TXT", "NS")]
        [parameter(Mandatory = $true)]
        [string]$Type,

        [ValidateSet(900, 3600, 10800, 21600, 43200, 86400)] #15m, 1h, 3h, 6h, 12h, 1day
        [int32]$TTL = 3600,

        [int32]$Priority
        
    )

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
        $request_body.records.add[0] += @{prio = $Priority }
    }
    if ($Name) {
        $request_body.records.add[0] += @{name = $Name }
    }

    try {
        $request = Invoke-OPRequest -Method Put -Endpoint "dns/zones/$($Domain)" -Body $request_body
        if ($request.data.success -eq $true) {
            Write-Host "Record has been succesfully created!"
            return $true | Out-Null
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
}