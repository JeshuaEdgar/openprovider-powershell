function Add-OPNameServer {
    param (
        [parameter(Mandatory = $true)]
        [string]$Name,

        [parameter(Mandatory = $true)]
        [string]$IP
    )

    $request_body = @{
        name = $Name
        ip   = $IP
    }

    try {
        $request = Invoke-OPRequest -Method Post -Endpoint "dns/nameservers" -Body $request_body
        if ($request.code -eq 0) {
            Write-Output "Nameserver $Name created succesfully!"
        }
        else {
            Write-Output $return.desc
        }
    }
    catch {
        $_.Exception.Message
    }
}