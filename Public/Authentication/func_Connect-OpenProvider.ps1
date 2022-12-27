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
        [pscredential]$Credential,

        [switch]$Sandbox
    )
    if (!$Credential) {
        $credential = Get-Credential
    }
    try {
        $encrypted_data = ConvertFrom-SecureString $Credential.Password
        $password_securestring = ConvertTo-SecureString $encrypted_data
        $password = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password_securestring))
    }
    catch {
        Write-Error $_.Exception.Message
        return
    }

    $token_body = @{
        username = $Credential.Username
        password = $password
    }

    if ($Sandbox) {
        # Set the sandbox URI
        $script:OpenProviderSession.Uri = "http://api.sandbox.openprovider.nl:8480/v1beta/"
    }

    try {
        $Session = Invoke-OPRequest -Method Post -Endpoint "auth/login" -Body $token_body
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