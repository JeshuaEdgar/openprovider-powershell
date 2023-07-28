function Update-OPNameserver {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$Name,

        [parameter(Mandatory = $true)]
        [string]$IP,

        [string]$IPv6
    )
    $request_body = @{
        ip   = $IP
        name = $Name
    }
    if ($IPv6) {
        $request_body.ip6 = $IPv6
    }

    try {
        $request = Invoke-OPRequest -Method Put -Endpoint "dns/nameservers/$Name" -Body $request_body
        if ($request.data.success -eq $true) {
            Write-Host "Succesfully updated nameserver $Name"
            return $true | Out-Null
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
}