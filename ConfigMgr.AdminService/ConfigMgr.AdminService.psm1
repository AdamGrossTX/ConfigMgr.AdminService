using module 'Enums\AdminServiceEnums.psm1'

$script:ModuleRoot = $PSScriptRoot
$script:tick = [char]0x221a

#region Get public and private function definition files.
$Public  = @(Get-ChildItem -Path $script:ModuleRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $script:ModuleRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
#endregion
#region Dot source the files
foreach ($import in @($Public + $Private))
{
    try
    {
        . $import.FullName
    }
    catch
    {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}
#endregion