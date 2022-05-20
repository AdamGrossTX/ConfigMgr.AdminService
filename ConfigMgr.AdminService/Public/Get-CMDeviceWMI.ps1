function Get-CMDeviceWMI {
    [cmdletbinding()]
    param (
        [int]$ResourceID,
        [string]$Name,
        [string]$AADDeviceID,
        [string]$SMSID,
        [string]$SerialNumber,
        [string]$SMBIOSGUID,
        [string]$Select
    )

    try {
        $Result = if ($ResourceID) {
            Invoke-CMGet -URI "$($script:ASWmiURI)SMS_R_System($ResourceId)"    
        }
        else {
            $FilterObjs = foreach ($key in ($PSBoundParameters.keys | Where-Object { $_ -notin ("ResourceId", "Select") })) {
                Get-FilterObject $Key $PSBoundParameters[$key]
            }
            $Filter = $FilterObjs | Get-FilterString
            if ($Select) {
                if ($Filter) {
                    $Filter = "$($Filter)&`$select=$($Select)"
                }
                else {
                    $Filter = "?`$select=$($Select)"
                }
            }
            Invoke-CMGet -URI "$($script:ASWmiURI)SMS_R_System$($Filter)"
        }
        return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
    }
    catch {

    }
}