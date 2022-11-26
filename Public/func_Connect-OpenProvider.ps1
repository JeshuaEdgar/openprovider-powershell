<#
.SYNOPSIS
    Connects to the OpenProvider API
.DESCRIPTION
    Connects to the OpenProvider API and test whether there is a good connection
.INPUTS
    -Credential : OpenProvider credentials
.EXAMPLE
    Connect-OP
    or:
    Connect-OP -Credential (Get-Credential)
#>

function Connect-OpenProvider {
    param(
        [pscredential]$Credential
    )
    if (!$Credential) {
        $credential = Get-Credential
    }
    $encrypted_data = ConvertFrom-SecureString $Credential.Password
    $password_securestring = ConvertTo-SecureString $encrypted_data
    $password = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password_securestring))

    $token_body = @{
        username = $Credential.Username
        password = $password
    } | ConvertTo-Json
    try {
        Set-Variable "op_auth_token" -Value (ConvertTo-SecureString (Invoke-RestMethod -Method Post "https://api.openprovider.eu/v1beta/auth/login" -Body $token_body).data.token -AsPlainText -Force) -Scope Script
        return $true
    }
    catch {
        Write-Error $_.desc
        return
    }
}