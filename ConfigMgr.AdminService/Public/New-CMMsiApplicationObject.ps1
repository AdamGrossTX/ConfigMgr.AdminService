function New-CMMsiApplicationObject {
    [cmdletbinding()]
    param (
        [string]$Name,
        [string]$Version,
        [string]$Language,
        [string]$Description,
        [string]$Publisher,
        [string]$MSIPath
    )

    Import-CMAssemblies $AssemblyPath | Out-Null
    
    $AppParams = @{
        Name        = $Name
        Version     = $Version
        Language    = $Language
        Description = $Description
        Publisher   = $Publisher
    }

    $App = New-CMApplicationObject @AppParams

    $MSIImporter = New-Object -TypeName "Microsoft.ConfigurationManagement.ApplicationManagement.MsiContentImporter"
    $DeploymentType = $MSIImporter.CreateDeploymentType($MSIPath)
    $DeploymentType.Installer.Contents[0].OnFastNetwork = [Microsoft.ConfigurationManagement.ApplicationManagement.ContentHandlingMode]::Download
    $DeploymentType.Installer.Contents[0].OnSlowNetwork = [Microsoft.ConfigurationManagement.ApplicationManagement.ContentHandlingMode]::Download
   
    $dt = $App.DeploymentTypes.Add($DeploymentType)
    
    Return $App
}