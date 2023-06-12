function Get-OPNameServer {
    [CmdletBinding()]
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

        if ($request.data.total -ge 1) {
            $return_object = @()
            foreach ($_ in $request.data.results) {
                $return_object += [PSCustomObject]@{
                    Name = $_.name
                    IP   = $_.ip
                    IPv6 = $_.ip6
                }
            }
        }
        else {
            Write-Warning "No nameserver(s) found"
        }
    }
    catch {
        throw $_.Exception.Message
    }
    return $return_object
}