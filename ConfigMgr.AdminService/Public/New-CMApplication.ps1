function New-CMApplication {
    [cmdletbinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [Microsoft.ConfigurationManagement.ApplicationManagement.NamedObject]$ApplicationObject
    )
    PROCESS {
        try {
            #Import-CMAssemblies $AssemblyPath
            $SDMPackageXML = [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::SerializeToSTring($ApplicationObject, $true)
            $Body = @{
                SDMPackageXML = $SDMPackageXML
            }
            Invoke-CMPost -URI "$($script:ASWmiURI)/SMS_Application" -Body $Body
        }
        catch {
            throw $_
        }
    }
}