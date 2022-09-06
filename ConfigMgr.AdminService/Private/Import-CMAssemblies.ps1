<#
.NOTES
Need to check the path on this one. Not sure it'll work like this
#>
function Import-CMAssemblies {
    [cmdletbinding()]
    param(
        [System.IO.FileInfo]$AssemblyPath = "$($PSScriptRoot)\bin"
    )
    try {
        #This is so bad...
        $DLLList = @(
            "Microsoft.ConfigurationManager.CommonBase.dll"
            "DcmObjectModel.dll"
            "Microsoft.ConfigurationManagement.ApplicationManagement.dll"
            "Microsoft.ConfigurationManagement.ApplicationManagement.MsiInstaller.dll"
        )

        $LoadedAssemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()
        foreach ($Dll in $DllList) {
            $DllPath = (Join-Path $AssemblyPath $Dll)
            if (!($DllPath -in $LoadedAssemblies.Location)) {
                Write-Verbose "$($DLLPath) Not Loaded. Loading..."
                Add-Type -Path "$($DllPath)"
            }
        }
    }
    catch {
        $_.Exception.LoaderExceptions
    }
}