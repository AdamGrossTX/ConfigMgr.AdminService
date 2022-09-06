function Get-CMScriptResult {
    param (
        [int]$ResourceId,
        [int]$OperationId,
        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )
    PROCESS {
        try {
            if ($InputObject) {
                $OperationId = $InputObject.OperationId
                $ResourceId = $InputObject.ResourceId
            }
            $Result = Invoke-CMGet -URI "$($script:ASVerURI)Device($($ResourceId))/AdminService.ScriptResult(OperationId=$($OperationId))" -ReturnErrorToCaller
            Return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
        }
        catch {
            throw $_
        }
    }
}