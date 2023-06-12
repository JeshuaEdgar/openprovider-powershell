function Remove-OPNameserver {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$Name
    )

    try {
        $request = Invoke-OPRequest -Method Delete -Endpoint "dns/nameservers/$Name"
        if ($request.data.success -eq $true) {
            Write-Host "Succesfully deleted $Name nameserver"
            return $true | Out-Null
        }
    }

    catch {
        throw $_.Exception.Message
    }
}