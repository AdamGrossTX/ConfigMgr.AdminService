function Invoke-CMApplicationInstall {
    [cmdletbinding()]
    param (
        [string]$CIGUID,
        [string[]]$SMSID,
        [switch]$OnDemand
    )
    try {
        $Body = if ($OnDemand.IsPresent) {
            @{
                Devices          = $SMSID
                InstallationType = 1
            }
        }
        else {
            @{
                Devices = $SMSID
            }
        }

        $Result = Invoke-CMPost -URI "$($script:ASVerURI)Application($($CIGUID))/AdminService.InstallApplication" -Body $Body
        return $Result
    }
    catch {

    }
}