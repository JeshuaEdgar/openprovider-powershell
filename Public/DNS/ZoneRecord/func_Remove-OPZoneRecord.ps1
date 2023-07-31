function Remove-OPZoneRecord {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline, DontShow)]
        [PSCustomObject]$InputObject,

        [parameter(ParameterSetName = "ManualInput", Position = 0)]
        [PSCustomObject]$Record
    )
    process {
        if ($InputObject) {
            $Record = $InputObject
        }

        elseif (-not $Record) {
            Write-Error "Missing 'Record'"
        }

        $RemoveRecord = @{
            name  = $Record.Name
            prio  = $Record.Priority
            ttl   = $Record.TTL
            value = $Record.Value
            type  = $Record.Type
        }

        try {
            $request_body = @{
                id      = $Record.ZoneID
                name    = $Record.Domain
                records = @{
                    remove = @(
                        $RemoveRecord
                    )
                }
            }
            $request = Invoke-OPRequest -Method "Put" -Endpoint "dns/zones/$($Record.Domain)" -Body $request_body
            if ($request.data.success -eq $true) {
                Write-Host "$($RemoveRecord.Type) record has been succesfully deleted for domain $($Record.Domain)!"
                return $true
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
}