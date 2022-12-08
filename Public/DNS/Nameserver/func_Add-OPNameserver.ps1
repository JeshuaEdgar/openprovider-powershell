function Add-OPNameServer {
    param (
        [parameter(Mandatory = $true)]
        [string]$Name,

        [parameter(Mandatory = $true)]
        [string]$IP,

        [string]$IPv6
    )

    $request_body = @{
        name = $Name
        ip   = $IP
    }
    if ($IPv6) {
        $request_body.ip6 = $IPv6
    }

    try {
        $request = Invoke-OPRequest -Method Post -Endpoint "dns/nameservers" -Body $request_body
        if (($request.data.name -eq $Name) -and ($request.data.ip -eq $IP) -and ($request.data.ip6 -eq $IPv6)) {
            Write-Host "Nameserver $Name created succesfully!"
            return $true
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
}