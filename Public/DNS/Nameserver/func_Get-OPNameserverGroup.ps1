function Get-OPNameserverGroup {
    try {
        $request = Invoke-OPRequest -Method Get -Endpoint "dns/nameservers/groups"
        if ($request.data.total -ge 1) {
            $return_object = @()
            $request.data.results | ForEach-Object {
                $return_object += [PSCustomObject]@{
                    GroupName = $_.ns_group
                    GroupID   = $_.id
                    # not sure whether to return a whole list of nameservers
                    # Nameservers = $_.name_servers
                }
            }
        }
        else {
            Write-Warning "No nameserver group(s) found"
        }
    }
    catch {
        throw $_.Exception.Message
    }
    return $return_object
}