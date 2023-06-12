function Add-OPNameServer {
    [CmdletBinding()]
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

        $diffObject = [PSCustomObject]@{
            name = $Name
            ip   = $IP
            ip6  = $IPv6
        }
        # validation
        $compare = Compare-Object -ReferenceObject $request.data -DifferenceObject $diffObject

        if ($request.code -eq 0 -and $compare -ne $true) {
            Write-Host "Nameserver $Name created succesfully!"
            return $true | Out-Null
        }
        else {
            Write-Warning "Output is different to input, please check manually in OpenProvider CP"
            Write-Warning "Domain: $Domain - IP: $IP - IPv6: $IPv6"
            return $false | Out-Null
        }
    }
    catch {
        throw $_.Exception.Message
    }
}