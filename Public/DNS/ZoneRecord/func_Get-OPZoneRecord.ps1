<#
.SYNOPSIS
    Get the Zone record(s) for a domain
.DESCRIPTION
    Get the Zone record(s) for a domain, optionally specify a zone provider with your request
.EXAMPLE
    Get-OPZoneRecord -Domain "testdomain.com" -Provider sectigo
#>

function Get-OPZoneRecord {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [PSCustomObject]$InputObject,

        [parameter(ParameterSetName = 'ManualInput')]
        [string]$Domain,

        [parameter(ParameterSetName = 'ManualInput')]
        [ValidateSet("openprovider", "sectigo")]
        [string]$Provider = "openprovider"
    )

    process {
        if ($InputObject) {
            $Domain = $InputObject.Domain
        }
        elseif (-not $Domain) {
            throw "'Domain' is a mandatory parameter! Please specify this parameter"
        }

        $request_splat = @{
            Method   = "Get"
            Endpoint = "dns/zones/$($Domain)/records"
            Body     = @{limit = 500; zone_provider = $Provider }
        }
    
        try {
            $request = Invoke-OPRequest @request_splat
            if ($request.data.total -gt 0) {
                $return_object = @()
                $request.data.results | ForEach-Object {
                    $return_object += [PSCustomObject]@{
                        Domain   = $Domain
                        Name     = ($_.name -replace $Domain, "") -replace ".$"
                        Priority = $_.prio
                        TTL      = $_.ttl
                        Type     = $_.type
                        Value    = $_.value.Replace('"', "")
                    }
                }
            }
            else {
                Write-Host "No $Provider zone records found for domain $Domain"
            }
        }
        catch {
            throw $_.Exception.Message
        }
        return $return_object 
    }
}