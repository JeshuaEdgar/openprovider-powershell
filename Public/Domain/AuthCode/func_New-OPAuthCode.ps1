function New-OPAuthCode {
    param (
        [parameter(Mandatory = $true)]
        [int]$DomainID
    )
    try {
        $request = Invoke-OPRequest -Method Get -Endpoint "domains/$($DomainID)/authcode"
        if ($request.data.success -eq $true) {
            $return_object = [PSCustomObject]@{
                DomainID = $DomainID
                AuthCode = $request.data.auth_code
            }
        }
        else {
            Write-Warning "Could not get AuthCode for domain ID $DomainID"
        }
    }
    catch {
        throw $_.Exception.Message
    }
    return $return_object
}