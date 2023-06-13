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

        [parameter(Mandatory = $true)]
        [string]$Domain,

        [ValidateSet("openprovider", "sectigo")]
        [string]$Provider = "openprovider"
    )

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
                    Name     = $_.name
                    Priority = $_.prio
                    TTL      = $_.ttl
                    Type     = $_.type
                    Value    = $_.value.Replace('"', "")
                }
            }
        }
        else {
            Write-Host "No zone records found for domain $Domain"
        }
    }
    catch {
        throw $_.Exception.Message
    }
    return $return_object 
}