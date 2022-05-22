function Get-CMKeyVault {
    [cmdletbinding()]
    param()
    try {
        $script:vault = $null
        $VaultParams = @{}
        #Add custom tags to key vault to find it later
        foreach ($key in $script:tag.keys) {
            $VaultParams[$key] = $script:tag[$key]
        }
        $ExistingVault = Get-SecretVault | Where-Object { $_.VaultParameters.Project -eq $script:tag.Project } -ErrorAction SilentlyContinue
        if ($ExistingVault) {
            if ($ExistingVault.ModuleName -eq "Microsoft.PowerShell.SecretStore") {
                Write-Host "Local Vault $($ExistingVault.Name) found." -ForegroundColor Cyan -NoNewline
                Write-Host $Script:tick -ForegroundColor yellow
                $script:vault = $ExistingVault
            }
            elseif ($ExistingVault.ModuleName -eq "Az.KeyVault") {
                Write-Host "Local Azure Key Vault $($ExistingVault.Name) found." -ForegroundColor Cyan -NoNewline
                Write-Host $Script:tick -ForegroundColor yellow
                $script:vault = $ExistingVault
            }
        }
        return $script:vault
    }
    catch {
        throw $_
    }
}