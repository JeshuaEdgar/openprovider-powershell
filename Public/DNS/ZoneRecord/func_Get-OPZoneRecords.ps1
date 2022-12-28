<#
.SYNOPSIS
    Get the Zone record(s) for a domain
.DESCRIPTION
    Get the Zone record(s) for a domain, optionally specify a zone provider with your request
.EXAMPLE
    Get-OPZoneRecord -Domain "testdomain.com" -Provider sectigo
#>

function Get-OPZoneRecords {
    param (
        [parameter(Mandatory = $true)]
        [string]$Domain,

        [ValidateSet("openprovider", "sectigo")]
        [string]$Provider
    )

    $request_splat = @{
        Method   = "Get"
        Endpoint = "dns/zones/$($Domain)/records"
    }
    if ($Provider) {
        $request_splat.Body += @{zone_provider = $Provider }
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
                    Value    = $_.value
                }
            }
        }
        else {
            Write-Output "No zone records found for domain $Domain"
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
    return $return_object
}