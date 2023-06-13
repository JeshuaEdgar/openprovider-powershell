function Remove-OPZoneRecord {
    param (
        [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [PSCustomObject]$InputObject,

        [parameter(ParameterSetName = "ManualInput")]
        [string]$Domain,

        [parameter(ParameterSetName = "ManualInput")]
        [string]$ZoneID,

        [parameter(ParameterSetName = "ManualInput")]
        [PCSutomObject]$Record
    )
    process {
        if ($InputObject) {
            $Domain = $InputObject.Domain
            $ZoneID = $InputObject.ZoneID
            $RemoveRecord = @{
                name  = $InputObject.Name
                prio  = $NewRecord.Priority
                ttl   = $NewRecord.TTL
                value = $NewRecord.Value
                type  = $NewRecord.Type
            }
        }
        elseif (-not ($Domain -and $ZoneID -and $Record)) {
            throw "Missing parameters, please check if 'Domain', 'ZoneID' and 'Record' are correct"
        }

        # if not passed through as pipeline
        $RemoveRecord = @{
            name  = $Record.name
            prio  = $Record.prio
            ttl   = $Record.ttl
            value = $Record.value
            type  = $Record.type
        }

        try {
            $request_body = @{
                id      = $ZoneID
                name    = $Domain
                records = @{
                    remove = @(
                        $RemoveRecord
                    )
                }
            }
            $request = Invoke-OPRequest -Method "Put" -Endpoint "dns/zones/$Domain" -Body $request_body
            if ($request.data.success -eq $true) {
                Write-Host "$($RemoveRecord.Type) record has been succesfully deleted for domain $Domain!"
                return $true | Out-Null
            }
        }
        catch {
            throw $_.Exception.Message
        }
    }
    
}