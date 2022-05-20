function Remove-CMUser {
    param (
        [int]$ResourceID,

        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )

    PROCESS {
        try {
            if ($InputObject) {
                $ResourceID = $InputObject.ResourceID
            }
            $Result = Invoke-CMDelete -URI "$($script:ASWmiURI)SMS_R_User($($ResourceID))"
            return $Result
        }
        catch {

        }
    }
}