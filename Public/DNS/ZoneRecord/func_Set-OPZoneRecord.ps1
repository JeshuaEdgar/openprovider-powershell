function Set-OPZoneRecord {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$Domain,

        [parameter(Mandatory = $true)]
        [string]$ZoneID,

        [parameter(Mandatory = $true)]
        [array]$OriginalRecord,

        [parameter(Mandatory = $true)]
        [array]$NewRecord

    )

    $request_body = @{
        id      = $ZoneID
        name    = $Domain
        records = @{
            update = @(
                @{
                    original_record = @{
                        # still have to fix this, works for now. needed to strip domain away from name since OP API delivers the records with domain but only accepts without for changes.
                        name  = ($OriginalRecord.name -replace $Domain, "").Trim(".")
                        prio  = $OriginalRecord.prio
                        ttl   = $OriginalRecord.ttl
                        value = $OriginalRecord.value
                        type  = $OriginalRecord.type
                    }
                    record          = @{
                        name  = $NewRecord.name
                        prio  = $NewRecord.prio
                        ttl   = $NewRecord.ttl
                        value = $NewRecord.value
                        type  = $NewRecord.type
                    }

                }
            )
        }
    }

    # return $request_body | ConvertTo-Json -depth 5

    try {
        $request = Invoke-OPRequest -Method Put -Endpoint "dns/zones/$Domain" -Body $request_body
        if ($request.data.success -eq $true) {
            Write-Host "Record has been succesfully set!"
            return $true | Out-Null
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
    
}