<#
.SYNOPSIS
    Disconnects to the OpenProvider API
.DESCRIPTION
    Disconnects to the OpenProvider API when connected to a previous session
.EXAMPLE
    Disconnect-OpenProvider
#>

function Disconnect-OpenProvider {
    if ($op_auth_token) {
        Remove-Variable op_auth_token -Scope Script
        return $true
    }
    else {
        Write-Error "There was no active connection to OpenProvider"
        return
    }
}