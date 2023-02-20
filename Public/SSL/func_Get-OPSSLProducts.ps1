function Get-OPSSLProducts {
    try {
        $request_body = @{
            with_price          = 'true'
            'order_by.category' = 'asc'
        }
        $request = Invoke-OPRequest -Method Get -Endpoint "ssl/products" -Body $request_body
        $return_object = @()
        foreach ($product in $request.data.results) {
            $return_object += [PSCustomObject] @{
                ID           = $product.id
                BrandName    = $product.brand_name
                Product      = $product.name
                MaxPeriod    = $product.max_period
                MinimumPrice = $product[0].prices[0].price.reseller.price
                Currency     = $product[0].prices[0].price.reseller.currency
                DeliveryTime = $product.delivery_time
            }
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
    return $return_object
}