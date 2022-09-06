Function Get-CMDeviceExtensionData {
    [cmdletbinding()]
    param (
        [string]$ResourceId
    )

    try {

        $Result = Invoke-CMGet -URI "$($script:ASVerURI)Device($ResourceId)/AdminService.GetExtensionData"
        return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
    }
    catch {

    }
    
}