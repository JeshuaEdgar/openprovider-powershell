function Get-OPDomainDetails {
    param (
        [parameter(Mandatory = $true)]
        [int]$ID
    )
    $request_body = @{
        id                   = $ID
        with_additional_data = $true
    }

    try {
        $request = Invoke-OPRequest -Method Get -Endpoint "domains/$ID" -Body $request_body
        return $request.data
    }
    catch {
        Write-Error $_.Exception.Message
    }
}