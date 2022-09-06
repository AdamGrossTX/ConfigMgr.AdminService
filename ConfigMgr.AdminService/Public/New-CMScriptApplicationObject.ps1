<#
.NOTES
Needs more DT Info added
#>
function New-CMScriptApplicationObject {
    [cmdletbinding()]
    param (
        [string]$Name,
        [string]$Version,
        [string]$Language,
        [string]$Description,
        [string]$Publisher,
        [string]$InstallCommandLine,
        [string]$UninstallCommandLine,
        [string]$RepairCommandLine,
        [string]$DetectionMethod,
        [string]$ContentSourcePath
    )

    try {

        Import-CMAssemblies $AssemblyPath 
        $AppParams = @{
            Name        = $Name
            Version     = $Version
            Language    = $Language
            Description = $Description
            Publisher   = $Publisher
        }

        $App = New-CMApplicationObject @AppParams
        $ObjID = "DeploymentType_{0}" -f (New-Guid).Guid.ToUpper()

        $DeploymentTypeID = New-Object -TypeName "Microsoft.ConfigurationManagement.ApplicationManagement.ObjectId" -ArgumentList @($App.Scope, $ObjID, 1)
        $DeploymentType = New-Object Microsoft.ConfigurationManagement.ApplicationManagement.DeploymentType($DeploymentTypeID, "Script")
        $DeploymentType.Title = $Name 
        $DeploymentType.Version = $Version 
        $DeploymentType.Description = $Description 
        #NEEDS MANY MORE FIELDS ADDED FOR DT

        if ($ContentSourcePath) {
            $Content = [Microsoft.ConfigurationManagement.ApplicationManagement.ContentImporter]::CreateContentFromFolder($ContentSourcePath)
            if ($Content) {
                $DeploymentType.Installer.Contents.Add($Content)
                $DeploymentType.Installer.InstallCommandLine = $InstallCommandLine 
                $DeploymentType.Installer.UninstallCommandLine = $UninstallCommandLine
                $DeploymentType.Installer.RepairCommandLine = $RepairCommandLine
                $DeploymentType.Installer.ProductCode = "{" + (New-Guid).Guid + "}"
                #https://github.com/vivek7rr/vivekrr.com/blob/d81ed6e2e5e34adea12816c0ba64d671caeede3c/SCCM%20Application%20creation.ps1
                $DeploymentType.Installer.DetectionMethod = [Microsoft.ConfigurationManagement.ApplicationManagement.DetectionMethod]::ProductCode
            }
        }

        $App.DeploymentTypes.Add($DeploymentType)

        Return $App
    }
    catch {
        throw $_
    }
}