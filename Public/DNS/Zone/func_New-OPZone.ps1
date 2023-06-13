function New-OPZone {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, Position = 0)]
        [string]$Domain,

        [parameter(Mandatory)]
        [ValidateSet("openprovider", "sectigo")]
        [string]$Provider

    )
    $request_body = @{
        domain   = @{
            extension = $Domain.Split(".")[1]
            name      = $Domain.Split(".")[0]
        }
        provider = $Provider
        type     = "master"
    }

    try {
        $request = Invoke-OPRequest -Method Post -Endpoint "dns/zones" -Body $request_body
        if ($request.data.success -eq $true) {
            $upperCaseProvider = $Provider[0].ToString().ToUpper() + $Provider.Substring(1)
            Write-Host "$($upperCaseProvider) zone for $Domain has been created succesfully!"
            return $true | Out-Null
        }
    }
    catch {
        throw $_.Exception.Message
    }
}