function Invoke-OPRequest {
    param (
        [ValidateSet("Delete", "Get", "Patch", "Post", "Put")]
        [parameter(Mandatory = $true)]
        [string]$Method,

        [parameter(Mandatory = $true)]
        [string]$Endpoint,

        [hashtable]$Body

    )
    $functionCallStack = (Get-PSCallStack | Select-Object -ExpandProperty FunctionName)[1]
    $functionExceptions = @("Connect-OpenProvider")
    
    if ([string]::IsNullOrEmpty($script:OpenProviderSession.AuthToken)) {
        if ($functionCallStack -notin $functionExceptions) {
            Write-Error "Please connect to OpenProvider first using: Connect-OpenProvider"
            return $false
        }
    }

    if ($functionCallStack -notin $functionExceptions) {
        # check token status
        $twohours = 120
        [int]$timespan = (New-TimeSpan -Start (Get-Date) -End $script:OpenProviderSession.TimeToRefresh).TotalMinutes
        if ($timespan -le $twohours) {
            Write-Warning "Your token will expire in $timespan minutes"
        }
        elseif ($timespan -le 0) {
            Write-Error "Token expired, please renew token using: Connect-OpenProvider"
        }
    }

    try {
        $request_splat = @{
            Method = $Method
            Uri    = ($script:OpenProviderSession.Uri + $Endpoint)
            Body   = $Body | ConvertTo-Json -Depth 4
        }
        if ($functionCallStack -notin $functionExceptions) {
            $request_splat.Headers += @{ Authorization = "Bearer $($OpenProviderSession.AuthToken)" }
        }
        $request = Invoke-RestMethod @request_splat
        return $request
    }
    catch {
        Write-Error -Message ((Format-ErrorCodes $_).ErrorMessage)
    }
}