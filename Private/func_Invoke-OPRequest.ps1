function Invoke-OPRequest {
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
            Body   = $Body | ConvertTo-Json -Depth 4
        }
        # check if get method + query params (powershell 5.1 compatibility)
        if ($Method -eq "Get" -and $Body) {
            $request_splat.Uri = ($script:OpenProviderSession.Uri + $Endpoint + (New-QueryString -Parameters $Body))
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
        if ($_.Exception -is [System.Net.WebException]) {
            throw (Format-ErrorCodes $_).ErrorMessage
        }
        elseif ($_.Exception -is [Microsoft.PowerShell.Commands.HttpResponseException]) {
            throw (Format-ErrorCodes $_).ErrorMessage
        }
        else {
            Write-Host "New error not being caught yet!"
            Write-Host $_.Exception.Message -ForegroundColor Yellow
            Write-Host $_.Exception.GetType().FullName -ForegroundColor Yellow
        }
    }
}