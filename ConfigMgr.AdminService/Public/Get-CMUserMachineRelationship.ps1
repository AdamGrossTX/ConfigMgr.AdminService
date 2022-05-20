function Get-CMUserMachineRelationship {
    [cmdletbinding()]
    param (
        [uint32]$ResourceID,
        [string]$UniqueUserName,
        [uint32]$RelationshipResourceID,
        [SourceType]$SourceType,
        [Parameter(ValueFromPipeline = $true)]
        [Object[]]$InputObject
    )

    PROCESS {
        if ($InputObject) {
            $ResourceID = if ($InputObject.MachineId) {
                $InputObject.MachineId
            }
            elseif ($InputObject.ResourceId) {
                $InputObject.ResourceId
            }
        }

        if ($RelationshipResourceID) {
            $Filter = "($($RelationshipResourceID))"
        }
        elseif ($ResourceID -or $UniqueUserName) {
            $filters = @(
                "$(if($ResourceID) {"ResourceId eq $($ResourceID)"}else{$null})",
                "$(if($UniqueUserName) {"UniqueUserName eq $($UniqueUserName)"}else{$null})"
            ) | Where-Object { $_ -ne '' }

            if ($filters.count -ge 1) {
                $Filter = "?`$filter="
                if ($filters.count -gt 1) {
                    $Filter = $Filter + ($filters -join " and ")
                }
                else {
                    $Filter = $Filter + $filters
                }
            }
        }
        else {
            $Filter = $null
        }

        try {
            $Result = Invoke-CMGet -URI "$($script:ASWmiURI)SMS_UserMachineRelationship$($Filter)"
            $RetVal = if ($Result -and $SourceType.Value__) {
                $Result | Where-Object { $_.Sources -contains $SourceType.Value__ }
            }
            else {
                $Result
            }
            return $RetVal
        }
        catch {

        }
    }

}