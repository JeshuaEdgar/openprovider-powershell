<#
.SYNOPSIS
    Disconnects to the OpenProvider API
.DESCRIPTION
    Disconnects to the OpenProvider API when connected to a previous session
.EXAMPLE
    Disconnect-OpenProvider
#>

function Disconnect-OpenProvider {
    if (-not [string]::IsNullOrEmpty($script:OpenProviderSession.AuthToken)) {
        $script:OpenProviderSession.AuthToken = $null
        $script:OpenProviderSession.TimeToRefresh = $null
        Write-Host "Succesfully disconnected to OpenProvider"
        return $true | Out-Null
    }
    else {
        Write-Warning "There was no active connection to OpenProvider"
        return $false | Out-Null
    }
}