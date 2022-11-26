<#
.SYNOPSIS
    Get the Zone ID for a domain
.DESCRIPTION
    Get the Zone ID for a domain, specify whether to look for OpenProvider free zones or premium Sectigo DNS zones
.EXAMPLE
    Get-OPZone -Domain "testdomain.com" -Sectigo
#>

function Get-OPZoneID {
    param (
        [parameter(Mandatory = $true)]
        [string]$Domain,
        [switch]$OpenProvider,
        [switch]$Sectigo
    )
    if (!$Sectigo -or !$OpenProvider) {
        Write-Error "Please select either OpenProvider or Sectigo"
    }
    if ($Sectigo) {
        $provider = "sectigo"
    }
    if ($OpenProvider) {
        $provider = "openprovider"
    }
    $request_body = @{
        provider = $provider
    }
    try {
        $ErrorActionPreference = 'Stop'
        return (Invoke-RestMethod -method get "https://api.openprovider.eu/v1beta/dns/zones/$($Domain)" -Authentication bearer -Token $op_auth_token -Body $request_body).data.id
    }
    catch {
        Write-Error "Cannot find Zone for domain $Domain"
    }
}
