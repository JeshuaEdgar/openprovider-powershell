function Get-OPNameServer {
    param (
        [string]$Name,
        [string]$IP
    )
    $request_body = @{
        name = $Name
    }
    if ($IP) {
        $request_body.ip = $IP
    }
    try {
        $request = Invoke-OPRequest -Method Get -Endpoint "dns/nameservers" -Body $request_body
        if ([int]$request.data.total -eq 0) {
            Write-Warning "No nameservers found"
        }
        else {
            return $request.data.results
        }
    }
    catch {
        $_.Exception.Message
    }
}