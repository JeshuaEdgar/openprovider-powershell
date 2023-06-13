function Set-OPZoneRecord {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline, DontShow)]
        [PSCustomObject]$InputObject,

        [parameter(ParameterSetName = "ManualInput", Position = 0)]
        [ValidateScript({
                if ($InputObject) {
                    throw "Cannot accept both pipeline input and 'Record' parameter"
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
            if (-not ($Name -or $Priority -or $TTL -or $Value)) {
                throw "No changes are defined!"
            }
            $Record = $InputObject
        }
        elseif (-not ($Record) -and -not ($Name -or $Priority -or $TTL -or $Value)) {
            throw "No changes are defined!"
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

        $request_body = @{
            id      = $Record.ZoneID
            name    = $Record.Domain
            records = @{
                update = @(
                    @{
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

                    }
                )
            }
        }
        try {
            $request = Invoke-OPRequest -Method Put -Endpoint "dns/zones/$($Record.Domain)" -Body $request_body
            if ($request.data.success -eq $true) {
                Write-Host "Record has been succesfully set!"
                return $true | Out-Null
            }
        }
        catch {
            throw $_.Exception.Message
        }
    }
}