function Get-OPCustomerInfo {
    param (
        [string]$CustomerName
    )
    try {
        $body = @{
            limit = 1000
        }
        if ($CustomerName -ne "") {
            $body.company_name_pattern = $CustomerName
        }
        $request = Invoke-OPRequest -Method Get -Endpoint "customers" -Body $body

        $returnObject = @()
        foreach ($customer in $request.data.results) {
            $returnObject += [PSCustomObject]@{
                ID     = $customer.id
                Name   = $customer.company_name
                Email  = $customer.email
                Handle = $customer.handle
            }
        }
    }
    catch {
        $_.Exception.Message
    }
    return $returnObject
}