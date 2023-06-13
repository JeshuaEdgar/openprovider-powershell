function Remove-OPZone {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, Position = 0)]
        [string]$Domain,

        [Parameter(Mandatory)]
        [ValidateSet("openprovider", "sectigo")]
        [string]$Provider
    )

    $request_body = @{
        provider = $Provider
    }

    try {
        $request = Invoke-OPRequest -Method Delete -Endpoint "dns/zones/$Domain" -Body $request_body
        if ($request.data.success -eq $true) {
            $upperCaseProvider = $Provider[0].ToString().ToUpper() + $Provider.Substring(1)
            Write-Host "Succesfully removed $upperCaseProvider zone for $Domain"
            return $true | Out-Null
        }
    }
    catch {
        throw $_.Exception.Message
    }
}