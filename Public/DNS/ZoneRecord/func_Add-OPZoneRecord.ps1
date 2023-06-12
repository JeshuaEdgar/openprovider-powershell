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
        [parameter(ValueFromPipeline = $true)]
        [PSCustomObject]$InputObject,

        [parameter(Mandatory = $true, ParameterSetName = 'PipelineInput')]
        [string]$Domain,

        [parameter(Mandatory = $true, ParameterSetName = 'PipelineInput')]
        [string]$ZoneID,

        [string]$Name,

        [parameter(Mandatory = $true, ParameterSetName = 'ManualInput')]
        [string]$Value,

        [ValidateSet("A", "AAAA", "CAA", "CNAME", "MX", "TXT", "NS")]
        [parameter(Mandatory = $true, ParameterSetName = 'ManualInput')]
        [string]$Type,

        [ValidateSet(900, 3600, 10800, 21600, 43200, 86400)] #15m, 1h, 3h, 6h, 12h, 1day
        [int]$TTL = 3600,

        [ValidateScript({
                if (!($PSBoundParameters["Type"] -eq "MX" -and $_ -is [int])) {
                    throw "MX Record Priority is not a valid integer, please adjust your input"
                }
                $true
            })]
        [int]$Priority = 0
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'PipelineInput') {
            $Domain = $InputObject.Domain
            $ZoneID = $InputObject.ZoneID
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
            throw $_.Exception.Message
        }
    }
}