function New-CMApplicationObject {
    [cmdletbinding()]
    param (
        [string]$Name,
        [string]$Version,
        [string]$Language,
        [string]$Description,
        [string]$Publisher
    )

    try {
        Import-CMAssemblies
        $ScopeID = New-CMScopeID
        $ObjID = "Application_{0}" -f (New-Guid).Guid.ToUpper()

        $ObjectId = New-Object -TypeName "Microsoft.ConfigurationManagement.ApplicationManagement.ObjectId" -ArgumentList @($ScopeID, $ObjID, 1)
        $App = New-Object -TypeName "Microsoft.ConfigurationManagement.ApplicationManagement.Application" -ArgumentList $objectId
        $DisplayInfo = New-Object -TypeName "Microsoft.ConfigurationManagement.ApplicationManagement.AppDisplayInfo"

        $App.Publisher = $Publisher 
        $App.Title = $Name 
        $App.Version = $Version
        $App.SoftwareVersion = $Version 
        $App.Description = $Description

        $DisplayInfo.Title = $Name
        $DisplayInfo.Description = $Description
        $DisplayInfo.Publisher = $Publisher 
        $DisplayInfo.Version = $Version
        $DisplayInfo.Language = if (-not $Language) { (Get-Culture).Name }else { $Language }

        $App.DisplayInfo.DefaultLanguage = $Language 
        $App.DisplayInfo.Add($DisplayInfo)

        Return $App
    }
    catch {
        throw $_
    }
}