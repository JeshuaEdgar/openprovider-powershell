function New-OPZone {
    param (
        [parameter(Mandatory = $true)]
        [string]$Domain,

        [parameter(Mandatory = $true)]
        [ValidateSet("openprovider", "sectigo")]
        [string]$Provider,

        [array]$Records
    )
    $request_body = @{
        domain   = @{
            extension = $Domain.Split(".")[1]
            name      = $Domain.Split(".")[0]
        }
        provider = $Provider
        type     = "master"
    }
    if ($Records) {
        $request_body.records = $Records
    }
    try {
        $request = Invoke-OPRequest -Method Post -Endpoint "dns/zones" -Body $request_body
        if ($request.code -eq 0) {
            Write-Host "Zone for $Domain has been created succesfully!"
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
}