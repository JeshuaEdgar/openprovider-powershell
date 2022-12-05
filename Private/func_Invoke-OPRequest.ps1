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
        return $false
    }

    # check token status
    $twohours = 120
    [int]$timespan = (New-TimeSpan -Start (Get-Date) -End $script:OpenProviderSession.TimeToRefresh).TotalMinutes
    if ($timespan -le $twohours) {
        Write-Warning "Your token will expire in $timespan hours"
    }
    elseif ($timespan -le 0) {
        Write-Error "Token expired, please renew token using: Connect-OpenProvider"
    }

    try {
        $bearer_token = @{
            Authorization = "Bearer $($OpenProviderSession.AuthToken)"
        }
        #convert body to
        $request_body = $Body | ConvertTo-Json -Depth 4

        $request = Invoke-RestMethod -Method $Method -Uri ($script:OpenProviderSession.Uri + $Endpoint) -Headers $bearer_token -Body $request_body
        return $request
    }
    catch {
        $output = ConvertFrom-Json $_
        Write-Error -Message $output.desc -ErrorId $output.code
    }
}