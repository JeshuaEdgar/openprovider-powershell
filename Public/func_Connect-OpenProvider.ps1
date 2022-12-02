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
        #only command that does not use Invoke-OPRequest to load up the token
        $Session = Invoke-RestMethod -Method Post "https://api.openprovider.eu/v1beta/auth/login" -Body $token_body
        if ($Session.code -eq 0) {
            $script:OpenProviderSession.AuthToken = $Session.data.token
            $script:OpenProviderSession.TimeToRefresh = (Get-Date).AddDays(2)
            $returnMessage = @(
                Write-Output "Welcome to OpenProvider!"
                Write-Output "Please be aware your token will expire on $($script:OpenProviderSession.TimeToRefresh)"
            )
            return $returnMessage
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
}