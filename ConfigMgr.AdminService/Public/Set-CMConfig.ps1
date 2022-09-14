function Set-CMConfig {
    param(
        [hashtable]$ConfigObj
    )
    try {

        if($ConfigObj.ASWmiURI) {$script:ASWmiURI = $ConfigObj.ASWmiURI}
        if($ConfigObj.ASURI) {$script:ASURI = $ConfigObj.ASURI}
        if($ConfigObj.ASVerURI) {$script:ASVerURI = $ConfigObj.ASVerURI}
        if($ConfigObj.vault) {$script:vault = $ConfigObj.vault}
        if($ConfigObj.AdminServiceAuthToken) {$script:AdminServiceAuthToken = $ConfigObj.AdminServiceAuthToken}
        Return $ConfigObj
    }
    catch {
        throw $_
    }
}