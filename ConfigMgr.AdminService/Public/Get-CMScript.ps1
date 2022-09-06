function Get-CMScript {
    [cmdletbinding()]
    param (
        [string]$ScriptGUID,
        [string]$ScriptName,
        [switch]$IncludeDetails
    )

    try {
        $Result = if ($ScriptGUID) {
            Invoke-CMGet -URI "$($script:ASWmiURI)SMS_Scripts('$ScriptGUID')"
        }
        else {
            $FilterObjs = foreach ($key in ($PSBoundParameters.keys | Where-Object { $_ -ne "ScriptGUID" })) {
                Get-FilterObject $Key $PSBoundParameters[$key]
            }
            $Filter = $FilterObjs | Get-FilterString
            Invoke-CMGet -URI "$($script:ASWmiURI)SMS_Scripts$($Filter)"
        }
        if ($IncludeDetails.IsPresent) {
            return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
        }
        else {
            return $Result | Select-Object -Property * -ExcludeProperty ParamsDefinition, Script, _*, `@odata*
        }
    }
    catch {

    }
}