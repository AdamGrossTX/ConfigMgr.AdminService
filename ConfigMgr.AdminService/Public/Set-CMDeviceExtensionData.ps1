Function Set-CMDeviceExtensionData {
    [cmdletbinding()]
    param (
        [string]$ResourceId,
        [hashtable]$ExtensionData
    )

    try {

        $Result = Invoke-CMPost -URI "$($script:ASVerURI)Device($ResourceId)/AdminService.SetExtensionData" -Body $ExtensionData
        return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
    }
    catch {
        throw $_
    }
}