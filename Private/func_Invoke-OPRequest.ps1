function Invoke-OPRequest {
    param (
        [ValidateSet("Delete", "Get", "Patch", "Post", "Put")]
        [parameter(Mandatory = $true)]
        [string]$Method,

        [parameter(Mandatory = $true)]
        [string]$Endpoint,

        [hashtable]$Body

    )
    if ([string]::IsNullOrEmpty($script:OpenProviderSession.AuthToken)) {
        Write-Error "Please connect to OpenProvider first using: Connect-OpenProvider"
    }
    if ($script:OpenProviderSession.TimeToRefresh -le (Get-Date)) {
        Write-Error "Token expired, please renew token using: Connect-OpenProvider"
    }

    try {
        $bearer_token = @{
            Authorization = "Bearer $($OpenProviderSession.AuthToken)"
        }
        #convert body to
        $request_body = $Body | ConvertTo-Json -Depth 4

        $request = Invoke-RestMethod -Uri ($script:OpenProviderSession.Uri + $Endpoint) -Headers $bearer_token -Body $request_body
        return $request
    }
    catch {
        Write-Error $_.Exception.Message
    }
}