function Invoke-CMApplicationUninstall {
    [cmdletbinding()]
    param (
        [string]$CIGUID,
        [string[]]$SMSID
    )
    try {
        $Body = @{
            Devices = $SMSID
        }
        $Result = Invoke-CMPost -URI "$($script:ASVerURI)Application$($CIGUID))/AdminService.UninstallApplication" -Body $Body
        return $Result
    }
    catch {

    }
}