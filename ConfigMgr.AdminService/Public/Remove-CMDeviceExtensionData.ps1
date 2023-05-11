Function Remove-CMDeviceExtensionData {
    [cmdletbinding()]
    param (
        [Parameter(mandatory=$true)]
        [string]$ResourceId
    )

    try {

        $Result = Invoke-CMPost -URI "$($script:ASVerURI)Device($ResourceId)/AdminService.DeleteExtensionData"
        return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
    }
    catch {
        throw $_
    }
}
