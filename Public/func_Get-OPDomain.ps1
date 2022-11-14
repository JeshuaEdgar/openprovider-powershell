function Get-OPDomain {
    param (
        [string]$Domain,
        [switch]$All
    )
    $domains = @()
    $limit = 500
    $offset = 0
    $total_domains = (Invoke-RestMethod -Method Get "https://api.openprovider.eu/v1beta/domains" -Authentication Bearer -Token $auth_token).data.total
    try {
        do {
            $domain_request_body = @{
                limit  = $limit
                offset = $offset
            }
            $domains += (Invoke-RestMethod -Method Get "https://api.openprovider.eu/v1beta/domains" -Authentication Bearer -Token $auth_token -Body $domain_request_body).data.results
            $offset += 500
        } until (
            $offset -ge $total_domains
        )
    }
    catch {
        $_.code
        $_.desc
    }
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