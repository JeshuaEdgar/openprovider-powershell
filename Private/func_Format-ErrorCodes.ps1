function Format-ErrorCodes {
    [CmdletBinding()]

    param (
        [parameter(Mandatory = $true)]
        $ErrorObject
    )
    try {
        # $ErrorActionPreference = "Stop"
        $errorCode = (($ErrorObject.ErrorDetails.Message | ConvertFrom-Json).code) # openprovider error code
        $errorDesc = (($ErrorObject.ErrorDetails.Message | ConvertFrom-Json).desc) # openprovider error desc
        $httpError = $ErrorObject.Exception.Response.StatusCode.value__ #http error code

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