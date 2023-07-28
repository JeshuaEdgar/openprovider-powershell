function Remove-OPZone {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline, DontShow)]
        [PSCustomObject]$InputObject,

        [parameter(Position = 0)]
        [string]$Domain,

        [ValidateSet("openprovider", "sectigo")]
        [string]$Provider
    )

    process { 
        if ($InputObject) {
            $Domain = $InputObject.Domain
            $Provider = $InputObject.Provider
        }
        elseif (-not($Domain -and $Provider)) {
            Write-Error "Missing parameter(s), both 'Domain' and 'Provider' need to provided"
        }

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
            Write-Error $_.Exception.Message
        } 
    }
}