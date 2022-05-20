function Remove-CMUserMachineRelationship {
    [cmdletbinding()]
    param (
        [uint32]$RelationshipResourceID,
        [SourceType]$SourceType,
        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )

    BEGIN {
        $Body = @{
            SourceId = $SourceType.value__
        }
    }
    PROCESS {
        try {
            if ($InputObject) {
                $RelationshipResourceID = $InputObject.RelationshipResourceID
            }

            $Result = if ($InputObject.Sources.count -le 1 -or -not $SourceType) {
                Invoke-CMDelete -URI "$($script:ASWmiURI)SMS_UserMachineRelationship($RelationshipResourceID)"
            }
            elseif ($SourceType) {
                Invoke-CMPost -URI "$($script:ASWmiURI)SMS_UserMachineRelationship($RelationshipResourceID)/AdminService.RemoveSource" -Body $Body
            }

            return $Result
        }
        catch {
            throw $_
        }
    }
}