function Invoke-OPRequest {
    [CmdletBinding()]
    param (
        [CmdletBinding()]

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
            throw "Please connect to OpenProvider first using: Connect-OpenProvider"
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
            throw "Token expired, please renew token using: Connect-OpenProvider"
        }
    }

    try {
        $request_splat = @{
            Method = $Method
            Uri    = ($script:OpenProviderSession.Uri + $Endpoint)
        }
        # check if get method + query params (powershell 5.1 compatibility)
        if ($Method -eq "Get" -and $Body) {
            $request_splat.Uri = ($script:OpenProviderSession.Uri + $Endpoint + (New-QueryString -Parameters $Body))
        }
        else {
            $request_splat.Body += $Body | ConvertTo-Json -Depth 4
        }
        # check if command is not being called from $functionExceptions
        if ($functionCallStack -notin $functionExceptions) {
            $request_splat.Headers += @{ Authorization = "Bearer $($OpenProviderSession.AuthToken)" }
        }
        # Write-Host $request_splat
        $request = Invoke-RestMethod @request_splat
        return $request
    }

    catch {
        throw (Format-ErrorCodes $_).ErrorMessage
    }
}