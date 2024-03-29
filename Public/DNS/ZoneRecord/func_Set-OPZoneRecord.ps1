function Set-OPZoneRecord {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline, DontShow)]
        [PSCustomObject]$InputObject,

        [parameter(ParameterSetName = "ManualInput", Position = 0)]
        [ValidateScript({
                if ($InputObject) {
                    Write-Error "Cannot accept both pipeline input and 'Record' parameter"
                }
                $true
            })]
        [PSCustomObject]$Record,

        [parameter(ParameterSetName = "ManualInput")]
        [string]$Name,
        
        [parameter(ParameterSetName = "ManualInput")]
        [int]$Priority,

        [parameter(ParameterSetName = "ManualInput")]
        [int]$TTL,

        [parameter(ParameterSetName = "ManualInput")]
        [string]$Value

    )
    process {
        if ($InputObject) {
            $Record = $InputObject
        }
        elseif (-not ($Record) -and -not ($Name -or $Priority -or $TTL -or $Value)) {
            Write-Error "No changes are defined!"
        }

        $NewRecord = $Record | ConvertTo-Json -Depth 100 | ConvertFrom-Json

        # Check and update the parameters for the new updated record
        if ($PSBoundParameters.ContainsKey('Name')) {
            $NewRecord.Name = $Name
        }
        if ($PSBoundParameters.ContainsKey('Priority')) {
            $NewRecord.Priority = $Priority
        }
        if ($PSBoundParameters.ContainsKey('TTL')) {
            $NewRecord.TTL = $TTL
        }
        if ($PSBoundParameters.ContainsKey('Value')) {
            $NewRecord.Value = $Value
        }

        $request_body = [ordered]@{
            id       = $Record.ZoneID
            name     = $Record.Domain
            provider = $Record.Provider
            records  = @{
                update = @( @{
                        original_record = @{
                            name  = $Record.Name
                            prio  = $Record.Priority
                            ttl   = $Record.TTL
                            value = $Record.Value
                            type  = $Record.Type
                        }
                        record          = @{
                            name  = $NewRecord.Name
                            prio  = $NewRecord.Priority
                            ttl   = $NewRecord.TTL
                            value = $NewRecord.Value
                            type  = $NewRecord.Type
                        }
                    })
            }
        }
        if ($Record.Type -eq "TXT") { $request_body.records.update.original_record.value = ('"{0}"' -f $Record.Value) }
        if ($NewRecord.Type -eq "TXT") { $request_body.records.update.record.value = ('"{0}"' -f $NewRecord.Value) }

        if ($null -ne $NewRecord.Priority) { $request_body.records.update.record.prio = $NewRecord.Priority }
        if ($null -ne $Record.Priority) { $request_body.records.update.record.prio = $Record.Priority }
        try {
            $request = Invoke-OPRequest -Method Put -Endpoint "dns/zones/$($Record.Domain)" -Body $request_body
            if ($request.data.success -eq $true) {
                Write-Host "Record has been succesfully set!"
                return $true
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
}