function Update-OPZone {
    param (
        [parameter(Mandatory = $true)]
        [String]$Domain,

        [ValidateSet("OpenProvider", "Sectigo")]
        [String]$Provider,

        [parameter(Mandatory = $true)]
        [int]$ZoneID,

        [switch]$IsSpamexpertsEnabled,

        [ValidateSet("Slave", "Master")]
        [string]$Type,

        [string]$MasterIP

    )
    $request_body = @{
        domain = @{
            extension = $Domain.Split(".")[1]
            name      = $Domain.Split(".")[0]
        }
        id     = $ZoneID
    }
    if ($IsSpamexpertsEnabled) {
        $request_body.is_spamexperts_enabled = $true
    }

    # check if master ip is set for slave and add to request body
    if ($Type) {
        if (($Type -eq "Slave") -and ([string]::IsNullOrEmpty($MasterIP))) {
            Write-Error "Please add a master IP to set $Domain to slave"
        }
        elseif (($Type -eq "Slave") -and $MasterIP) {
            $request_body.master_ip = $MasterIP
        }
        $request_body.type = $Type
    }

    try {
        $request = Invoke-OPRequest -Method Put -Endpoint "dns/zones/$Domain" -Body $request_body
        if ($request.code -eq 0) {
            Write-Host "Succesfully update the zone for $Domain"
        }
    }
    catch {
        $_.Exception.Message    
    }
}