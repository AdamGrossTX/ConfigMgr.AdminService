function Remove-CMCollection {
    [cmdletbinding()]
    param (
        [string]$CollectionID,

        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )

    PROCESS {
        try {
            if ($InputObject) {
                $CollectionID = $InputObject.CollectionID
            }
            $Result = Invoke-CMDelete -URI "$($script:ASWmiURI)SMS_Collection('$($CollectionID)')"
            return $Result
        }
        catch {

        }
    }
}
