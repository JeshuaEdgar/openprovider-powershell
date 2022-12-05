function Remove-OPNameserver {
    param (
        [parameter(Mandatory = $true)]
        [string]$Name
    )

    try {
        $request = Invoke-OPRequest -Method Delete -Endpoint "dns/nameservers/$Name"
        if ($request.data.success -eq $true) {
            return $true
        }
    }
    catch {
        $_.Exception.Message
        Write-Error "Failed to remove nameserver $Name"
    }
}