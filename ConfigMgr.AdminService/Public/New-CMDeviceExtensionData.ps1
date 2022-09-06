
#https://github.com/AdamGrossTX/Toolbox/blob/20a5fa6ad676572291b98ac5fad21a556aaa8135/Demo%20Content/Graph%20API%20and%20AdminService%20(MMSMiami)/Set-ManagedDeviceName.ps1
#"$($DeviceClassURL)($($CMDevice.ResourceId))/AdminService.GetExtensionData"


function New-CMDeviceExtensionData {
    [cmdletbinding()]
    param (
        [uint32]$MachineResourceId,
        [string]$UserAccountName,
        [SourceType]$SourceType = "OSDDefined", #OSD Defined
        [RelationshipType]$TypeId = "MyComputers",
        [switch]$RemoveThisSourceOnly,
        [switch]$RemoveAllOtherSources,
        [switch]$RemoveAllExisting
    )
    try {
        $Body = @{
            MachineResourceId = $MachineResourceId
            UserAccountName   = $UserAccountName
            SourceId          = $SourceType.Value__
            TypeId            = $TypeId.Value__
        }

        $Relationships = Get-CMUserMachineRelationship -ResourceId $MachineResourceId

        if ($Relationships) {
            if ($RemoveThisSourceOnly.IsPresent -or $RemoveAllOtherSources.IsPresent -or $RemoveAllExisting.IsPresent) {
                if ($RemoveAllOtherSources.IsPresent) {
                    $RelationShips | Where-Object { $_.Sources -notcontains $SourceType.Value__ } | Remove-CMUserMachineRelationship -ErrorAction SilentlyContinue
                }
                elseif ($RemoveThisSourceOnly.IsPresent) {
                    $RelationShips | Where-Object { $_.Sources -contains $SourceType.Value__ } | Remove-CMUserMachineRelationship -SourceType $SourceType.Value__ -ErrorAction SilentlyContinue
                }
                elseif ($RemoveAllExisting.IsPresent) {
                    $RelationShips | Remove-CMUserMachineRelationship -ErrorAction SilentlyContinue
                }
            }
        }

        $Result = Invoke-CMPost -URI "$($script:ASWmiURI)SMS_UserMachineRelationship.CreateRelationship" -Body $Body
        Return $Result.ReturnValue
    }
    catch {

    }
}