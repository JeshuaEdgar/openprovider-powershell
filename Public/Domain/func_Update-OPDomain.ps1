function Update-OPDomain {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [int]$DomainID,

        [ValidateSet("on", "off", "default")]
        [string]$AutoRenew,

        [string]$Comments,

        [string]$NameserverGroup,

        [bool]$EnableSpamExperts,

        [bool]$EnableSectigo,

        [bool]$EnablePrivateWhoIs,

        [bool]$Locked,

        [bool]$EnableDNSSEC
    )

    $paramExceptions = @("DomainID")

    $paramReplacements = @{
        "AutoRenew"          = "autorenew"
        "Comments"           = "comments"
        "NameserverGroup"    = "ns_group"
        "EnableSpamExperts"  = "is_spamexperts_enabled"
        "EnableSectigo"      = "is_sectigo_dns_enabled"
        "EnablePrivateWhoIs" = "is_private_whois_enabled"
        "Locked"             = "is_locked"
        "EnableDNSSEC"       = "is_dnssec_enabled"
    }

    $request_body = @{}

    # create a request body based on inputs and translate them so the API understands
    $PSBoundParameters.Keys | ForEach-Object {
        $keyName = $_
        if ($keyName -notin $paramExceptions) {
            $keyName = $paramReplacements[$keyName]
            $request_body += @{ $keyName = $PSBoundParameters.$_ }
        }
    }

    try {
        $request = Invoke-OPRequest -Method Put -Endpoint "domains/$DomainID" -Body $request_body
        if ($request.data.status -eq "ACT") {
            Write-Host "Domain updated succesfully!"
            return $true | Out-Null
        }
    }
    catch {
        throw $_.Exception.Message
    }
}