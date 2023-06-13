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
        [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, DontShow)]
        [PSCustomObject]$InputObject,

        [parameter(ParameterSetName = "ManualInput", Position = 0)]
        [string]$Domain,

        [parameter(ParameterSetName = "ManualInput")]
        [string]$ZoneID,

        [parameter(ParameterSetName = "ManualInput")]
        [string]$Name,

        [parameter(Mandatory, ParameterSetName = "ManualInput")]
        [string]$Value,

        [ValidateSet("A", "AAAA", "CAA", "CNAME", "MX", "TXT", "NS")]
        [parameter(Mandatory, ParameterSetName = "ManualInput")]
        [string]$Type,

        [parameter(ParameterSetName = "ManualInput")]
        [ValidateSet(900, 3600, 10800, 21600, 43200, 86400)] #15m, 1h, 3h, 6h, 12h, 1day
        [int]$TTL = 3600,

        [parameter(ParameterSetName = "ManualInput")]
        [ValidateScript({
                if (!($PSBoundParameters["Type"] -eq "MX" -and $_ -is [int])) {
                    throw "MX Record Priority is not a valid integer, please adjust your input"
                }
                $true
            })]
        [int]$Priority = 0
    )

    process {
        if ($InputObject) {
            $Domain = $InputObject.Domain
            $ZoneID = $InputObject.ZoneID
        }
        elseif (-not ($Domain -and $ZoneID)) {
            throw "'Domain' and 'ZoneID' are mandatory parameters! Please add the missing parameter(s)"
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
                Write-Host "$($Type) record has been succesfully created for domain $($Domain)!"
                return $true | Out-Null
            }
        }
        catch {
            throw $_.Exception.Message
        }
    }
}