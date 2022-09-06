function Get-CMApplication {
    [cmdletbinding()]
    param (
        [string]$CI_ID,
        [string]$LocalizedDisplayName,
        [string]$DisplayName,
        [string]$Manufacturer,
        [int]$ModelId,
        [string]$CIGUID,
        [string]$ModelName,
        [switch]$IncludeSDMPackageXML
    )

    try {
        $Result = if ($CI_ID) {
            Invoke-CMGet -URI "$($script:ASWmiURI)SMS_Application($($CI_ID))"
        }
        else {
            $FilterObjs = foreach ($key in ($PSBoundParameters.keys | Where-Object { $_ -ne "CI_ID" })) {
                Get-FilterObject $Key $PSBoundParameters[$key]
            }
            $Filter = $FilterObjs | Get-FilterString

            if ($DisplayName -or $CIGUID) {
                Invoke-CMGet -URI "$($script:ASVerURI)Application$($Filter)"
            }
            else {
                Invoke-CMGet -URI "$($script:ASWmiURI)SMS_Application$($Filter)"
            }
        }
        if ($IncludeSDMPackageXML) {
            return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
        }
        else {
            return $Result | Select-Object -Property * -ExcludeProperty _*, SDMPackageXML, `@odata*
        }

    }
    catch {

    }
}
