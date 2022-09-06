function New-CMDirectRule {
    [OutputType([hashtable])]
    [cmdletbinding(DefaultParameterSetName = "Params")]
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "InputObject", Position = 0)]
        [object]$InputObject,

        [parameter(Mandatory = $True, ParameterSetName = "Params", Position = 0)]
        [int]$ResourceId,

        [parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = "Params", Position = 1)]
        [parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = "InputObject", Position = 1)]
        [string]$RuleName,

        [parameter(Mandatory = $False, ParameterSetName = "Params", Position = 2)]
        [validateset("Device", "User")]
        [string]$Type = "Device"
    )

    PROCESS {
        try {
            if ($InputObject) {
                $Type = if ($InputObject | Get-Member -Name "UniqueUserName") {
                    "User"
                }
                else {
                    "Device"
                }
                $ResourceId = if ($InputObject.MachineId) { $InputObject.MachineId } else { $InputObject.ResourceID }
                $RuleName = $InputObject.Name
            }

            $ResourceClassName = switch ($Type) {
                "Device" { "SMS_R_System" }
                "User" { "SMS_R_User" }
                default { "SMS_R_System" }
            }

            $RuleName = if (-not $RuleName) { $ResourceId } else { $RuleName }

            $RuleObject = if ($RuleName, $ResourceClassName, $ResourceID) {
                @{
                    collectionRule = @{
                        "@odata.type"     = "#AdminService.SMS_CollectionRuleDirect"
                        ResourceClassName = $ResourceClassName
                        RuleName          = $RuleName
                        ResourceID        = $ResourceID
                    }
                }
            }
            else {
                $null
            }
    
            return $RuleObject
        }
        catch {
            throw $_
        }
    }
}