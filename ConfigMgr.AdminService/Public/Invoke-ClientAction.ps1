function Invoke-CMClientAction {
    [cmdletbinding()]
    param (
        [uint32[]]$TargetResourceIDs,
        [ClientAction]$Type,
        [uint32]$RandomizationWindow = 1,
        [string]$TargetCollectionID = "SMS00001"
    )
    try {
        $Body = @{
            TargetCollectionID  = $TargetCollectionID
            Type                = $Type.Value__
            RandomizationWindow = $RandomizationWindow
            TargetResourceIDs   = $TargetResourceIDs
        }

        $ClientOpsResult = Invoke-CMPost -URI "$($script:ASWmiURI)SMS_ClientOperation.InitiateClientOperation" -Body $Body
        $ClientOpsStatus = Invoke-CMGet -URI "$($script:ASWmiURI)SMS_ClientOperationStatus($($ClientOpsResult.OperationID))"
        $Result = $ClientOpsStatus | Select-Object -Property * -ExcludeProperty _*, `@odata*
        Return $Result
    }
    catch {

    }
}