function Format-ErrorCodes {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        $ErrorObject
    )

    try {
        $httpError = $ErrorObject.Exception.Response.StatusCode.value__ #http error code (universal)

        switch ($PSVersionTable.PSEdition) {
            "Desktop" {
                $ErrorObject = New-Object System.IO.StreamReader($ErrorObject.Exception.Response.GetResponseStream())
                $ErrorObject.BaseStream.Position = 0 
                $ErrorObject.DiscardBufferedData() 
                $ErrorObject = $ErrorObject.ReadToEnd()
            }
            "Core" { $ErrorObject = $ErrorObject.ErrorDetails.Message }
        }

        $errorCode = (($ErrorObject | ConvertFrom-Json).code) # openprovider error code
        $errorDesc = (($ErrorObject | ConvertFrom-Json).desc) # openprovider error desc

        $return_object = [PSCustomObject]@{
            OpenProviderErrorCode = $errorCode
            OpenProviderErrorDesc = $errorDesc
            HttpErrorCode         = $httpError
            ErrorMessage          = [string]"Error $errorCode! $errorDesc"
        }
        return $return_object
    }
    catch {
        Write-Error "Format-ErrorCodes - Failed to convert error codes"
    }
}