function Update-OPNameserver {
    param(
        [parameter(Mandatory = $true)]
        [string]$Name,

        [parameter(Mandatory = $true)]
        [string]$IP
    )
    $request_body = @{
        ip   = $IP
        name = $Name
    }
    try {
        $request = Invoke-OPRequest -Method Put -Endpoint "dns/nameservers/$Name" -Body $request_body
        if ($request.data.success -eq $true) {
            return $true
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
}