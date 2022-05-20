function New-CMScopeID {
    [cmdletbinding()]
    param ()
    try {
        Import-CMAssemblies
        $Result = Invoke-CMGet -URI "$($script:ASWmiURI)SMS_Identification.GetSiteId"
        if ($Result.SiteID) {
            $SiteID = $Result.SiteID.Replace("{", "").Replace("}", "").ToUpper()
            $ScopeID = "ScopeId_$($SiteID)"
            [Microsoft.ConfigurationManagement.ApplicationManagement.NamedObject]::DefaultScope = $ScopeID
            return $ScopeID
        }
        else {
            return $null
        }
    }
    catch {
        throw $_
    }
}