function New-OPRequest {
    param (
        [ValidateSet("Delete", "Get", "Patch", "Post", "Put")]
        [parameter(Mandatory = $true)]
        [string]$Method,

        [parameter(Mandatory = $true)]
        [string]$Endpoint,

        [parameter(Mandatory = $true)]
        [hashtable]$Body

    )
    if ($OpenProviderSession.TimeToRefresh -le (Get-Date)) {
        Write-Error "Token expired, please renew token using: Connect-OpenProvider"
    }
    if ([string]::IsNullOrEmpty($OpenProviderSession.Token)) {
        Write-Error "Please connect to OpenProvider first using: Connect-OpenProvider"
    }
}