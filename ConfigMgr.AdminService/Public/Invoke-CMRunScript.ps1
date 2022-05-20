function Invoke-CMRunScript {
    [cmdletbinding()]
    param (
        [string]$ScriptGuid,
        [string]$ScriptName,
        [int]$ResourceId,
        [string]$DeviceName,
        [switch]$WaitForResult,
        [int]$SecondsToWait,
        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )
    PROCESS {
        try {
            if ($ScriptName -and -not $ScriptGuid) {
                $Script = Get-CMScript -ScriptName $ScriptName
                if ($Script) {
                    $ScriptGuid = $Script.ScriptGUID
                }
                else {
                    Write-Host "No Script found with that name." -ForegroundColor Yellow
                }
            }

            $Device = $InputObject

            if ($DeviceName -and -not $ResouceId) {
                $Device = Get-CMDevice -Name $DeviceName
            }
            if ($Device) {
                $ResourceId = $Device.MachineId
            }
            $Body = @{
                ScriptGuid = $ScriptGuid
            }
            #If you get a 403 here - it's cause the script has been denied and not allowed to run most likely.
            $Result = Invoke-CMPost -URI "$($script:ASVerURI)Device($($ResourceId))/AdminService.RunScript" -Body $Body -ReturnErrorToCaller
            $ResultObj = if ($Result -is [int]) {
                [PSCustomObject]@{
                    OperationId = $Result
                    ResourceId  = $ResourceId
                }
            }
            else {
                $null
            }

            if ($WaitForResult) {
                $ResultObj | Invoke-WaitScriptResult -SecondsToWait $SecondsToWait
            }
            else {
                Return $ResultObj
            }
        }
        catch [System.Net.WebException] {
            $HttpResultCode = $_.Exception.Response.StatusCode.value__
            if ($HttpResultCode -eq 403) {
                Write-Verbose "Access Denied. Likely need to approve script"
                return "Access Denied."
            }
            else {
                throw $_
            }
        }
        catch {
            throw $_
        }
    }
}