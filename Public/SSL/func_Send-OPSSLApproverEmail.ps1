function Send-OPSSLApproverEmail {
    param (
        [int32]$OrderID
    )
    try {
        $body = @{
            id = $OrderID
        }
        $request = Invoke-OPRequest -Method Post -Endpoint "ssl/orders/$($OrderID)/approver-email/resend" -Body $body
        if (($request.data.id -eq $OrderID) -and ($request.code -eq 0)) {
            $returnCode = $true
        }
    }
    catch {
        $_.Exception.Message
        return $false | Out-Null
    }
    return $returnCode | Out-Null
}