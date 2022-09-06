function Approve-CMScript {
    [cmdletbinding(DefaultParameterSetName="ScriptName")]
    param (
        [Parameter(Mandatory = $True, ParameterSetName = "ScriptGUID")]
        [string]$ScriptGuid,

        [Parameter(Mandatory = $True, ParameterSetName = "ScriptName")]
        [string]$ScriptName,

        [Parameter(Mandatory = $False)]
        [string]$Comments
    )

    #ApprovalState
    #WaitingForApproval = 0
    #Deny = 1
    #Approve = 3
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
        $Body = @{
            Approver      = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
            ApprovalState = "3" #Approved
            Comment       = $Comments
        }

        $Result = Invoke-CMPost -URI "$($script:ASWmiURI)SMS_Scripts/$($ScriptGuid)/AdminService.UpdateApprovalState" -Body $Body
        Return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
    }
    catch {
        throw $_
    }
}