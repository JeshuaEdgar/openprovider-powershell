function Get-OPDomain {
    param (
        [parameter(Mandatory = $true)]
        [string]$Domain,
        [switch]$All
    )
    $domains = @()
    $limit = 500
    $offset = 0
    $total_domains = (Invoke-RestMethod -Method Get "https://api.openprovider.eu/v1beta/domains" -Authentication Bearer -Token $op_auth_token).data.total
    try {
        do {
            $domain_request_body = @{
                limit  = $limit
                offset = $offset
            }
            $domains += (Invoke-RestMethod -Method Get "https://api.openprovider.eu/v1beta/domains" -Authentication Bearer -Token $op_auth_token -Body $domain_request_body).data.results
            $offset += 500
        } until (
            $offset -ge $total_domains
        )
        if ($Domain) {
            $filter = [PSCustomObject]@{
                name      = $Domain.Split(".")[0]
                extension = $Domain.Split(".")[1]
            }
            return $domains | Where-Object { $_.domain -like $filter }
        }
        else {
            return $domains
        }
    }
    catch {
        $_.code
        $_.desc
    }
}