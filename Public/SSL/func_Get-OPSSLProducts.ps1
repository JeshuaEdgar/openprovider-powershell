function Get-OPSSLProducts {
    try {
        $request_body = @{
            with_price               = 'true'
            'order_by.product_seqno' = 'asc'
        }

        $request = Invoke-OPRequest -Method Get -Endpoint "ssl/products" -Body $request_body -verbose

        $return_object = @()
        foreach ($product in $request.data.results) {
            $return_object += [PSCustomObject] @{
                BrandName    = $product.brand_name
                Name         = $product.name
                ID           = $product.id
                MaxPeriod    = $product.max_period
                Price        = "$($product[0].prices.price.reseller.price) + $($product[0].prices.price.reseller.currency)"
                DeliveryTime = $product.delivery_time
            }
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }

    return $return_object
}