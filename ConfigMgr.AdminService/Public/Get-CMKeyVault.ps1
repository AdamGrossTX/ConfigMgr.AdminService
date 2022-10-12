function Get-CMKeyVault {
    [cmdletbinding()]
    param(
        [string]$AzureKeyVaultName
    )
    try {
        $script:vault = $null
        $VaultParams = @{}
        #Add custom tags to key vault to find it later
        foreach ($key in $script:tag.keys) {
            $VaultParams[$key] = $script:tag[$key]
        }

        $ExistingVault = if($AzureKeyVaultName) {
            Get-AzKeyVault -VaultName $AzureKeyVaultName
        }
        else {
            Get-SecretVault | Where-Object { $_.VaultParameters.Project -eq $script:tag.Project } -ErrorAction SilentlyContinue
        }
        if ($ExistingVault) {
            if($AzureKeyVaultName) {
                $script:vault = $ExistingVault
            }
            elseif ($ExistingVault.ModuleName -eq "Microsoft.PowerShell.SecretStore") {
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

