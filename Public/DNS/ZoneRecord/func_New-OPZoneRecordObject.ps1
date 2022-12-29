function New-OPZoneRecordObject {
    [CmdletBinding()]
    param (
        [string]$Name,

        [parameter(Mandatory = $true)]
        [string]$Value,

        [ValidateSet("A", "AAAA", "CAA", "CNAME", "MX", "TXT", "NS")]
        [parameter(Mandatory = $true)]
        [string]$Type,

        [ValidateSet(900, 3600, 10800, 21600, 43200, 86400)] #15m, 1h, 3h, 6h, 12h, 1day
        [int]$TTL,

        [int]$Priority

    )

    # if TTL is not given, set to 1hour by default
    if (!$TTL) {
        $TTL = 3600
    }

    $record_object = [PSCustomObject]@{
        ttl   = $TTL
        type  = $Type
        value = $Value
    }

    if ($Type -eq "MX") {
        if (!$Priority) {
            Write-Error "Please set the priority for the $Type record"
            return
        }
        $record_object | Add-Member -NotePropertyMembers @{prio = $Priority }
    }

    if ($Name) {
        $record_object | Add-Member -NotePropertyMembers @{name = $Name }
    }

    return $record_object
}