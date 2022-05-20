function Get-CMUser {
    param (
        [int]$ResourceID,
        [string]$Name,
        [string]$AADDeviceID,
        [string]$UserPrincipalName,
        [string]$UserName,
        [string]$SID,
        [string]$FullUserName,
        [string]$UniqueUserName,
        [string]$Select
    )

    try {
        $Result = if ($ResourceID) {
            Invoke-CMGet -URI "$($script:ASWmiURI)SMS_R_User($ResourceID)"
        }
        else {
            $FilterObjs = foreach ($key in ($PSBoundParameters.keys | Where-Object { $_ -notin ("ResourceId", "Select")})) {
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
            Invoke-CMGet -URI "$($script:ASWmiURI)SMS_R_User$($Filter)"
        }
        return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
    }
    catch {
        throw $_
    }
}