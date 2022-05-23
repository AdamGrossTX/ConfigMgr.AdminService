function Set-CMKeyVaultValues {
    [cmdletbinding(DefaultParameterSetName = "DefaultSecrets")]
    param (
        [parameter(mandatory = $true, ParameterSetName = "DefaultSecrets")]
        [string]$AdminServiceTenantId,
        
        [parameter(mandatory = $false)]
        [hashtable]$Tag = @{Project = "ConfigMgr.AdminService" },
        
        [parameter(mandatory = $true, ParameterSetName = "DefaultSecrets")]
        [string]$AdminServiceBaseURL,
        
        [parameter(mandatory = $true, ParameterSetName = "DefaultSecrets")]
        [string]$AdminServiceCMGURL,
        
        [parameter(mandatory = $true, ParameterSetName = "DefaultSecrets")]
        [string]$AdminServiceClientAppId,
        
        [parameter(mandatory = $true, ParameterSetName = "DefaultSecrets")]
        [string]$AdminServiceServerAppId,
        
        [parameter(mandatory = $true, ParameterSetName = "DefaultSecrets")]
        [string]$AdminServiceServerAppIdUri,

        [parameter(mandatory = $true, ParameterSetName = "CustomSecrets")]
        [hashtable]$Secrets,
        
        [parameter(mandatory = $false, ParameterSetName = "DefaultSecrets")]
        [parameter(mandatory = $false, ParameterSetName = "CustomSecrets")]
        $ReAuthAzureKeyVault
    )

    try {
        if ($Tag) {
            $script:Tag = $Tag
        }

        if (-not $Secrets) {
            $Secrets = @{
                AdminServiceTenantId       = $AdminServiceTenantId
                AdminServiceClientAppId    = $AdminServiceClientAppId
                AdminServiceServerAppId    = $AdminServiceServerAppId
                AdminServiceServerAppIdUri = $AdminServiceServerAppIdUri
                AdminServiceBaseURL        = $AdminServiceBaseURL
                AdminServiceCMGURL         = $AdminServiceCMGURL
            }
        }

        if (-not $script:vault) {
            Get-CMKeyVault | Out-Null
        }
        if ($script:vault.ModuleName -eq "Az.KeyVault") {
            if (-not (Get-Module -Name Az.KeyVault -ListAvailable)) {
                Install-Module Az.KeyVault
            }
            Import-Module Az.KeyVault
    
            if ($ReAuthAzureKeyVault) {
                Clear-AzContext -Force -Confirm:$False -ErrorAction SilentlyContinue
            }
        
            $Context = Get-AzContext -ErrorAction SilentlyContinue
            if(-not $Context) {
                Write-Host "Connecting to Azure Account. Log in with Account with rights to create a Resource Group and Key Vault." -ForegroundColor Cyan -NoNewline
                Connect-AzAccount | Out-Null
                Write-Host $script:tick -ForegroundColor Yellow
            }

            #Clear-AzContext -Force -Confirm:$False -ErrorAction SilentlyContinue
    
    
            $Vault = Get-AZKeyVault -VaultName $script:vault.VaultParameters.AZKVaultName -ErrorAction SilentlyContinue
            if (-not $Vault) {
                return "No Vault"
            }
            else {
                Write-Host "Creating Secrets:" -ForegroundColor Cyan
                foreach ($key in $Secrets.keys) {
                    $Secret = if ($Secrets[$key] -isnot [securestring]) {
                        ConvertTo-SecureString -String $Secrets[$key] -AsPlainText
                    }
                    else {
                        $Secrets[$key]
                    }
                    Set-AzKeyVaultSecret -VaultName $Vault.VaultName -Name $Key -SecretValue $Secret -Tag $Tag
                    Write-Host "  $($key)" -ForegroundColor green
                }
                Write-Host $script:tick -ForegroundColor Yellow
            }
        }
        elseif ($script:vault.ModuleName -eq "Microsoft.PowerShell.SecretStore") {
            Write-Host "Creating Secrets:" -ForegroundColor Cyan
            foreach ($key in $Secrets.keys) {
                $Secret = if ($Secrets[$key] -isnot [securestring]) {
                    ConvertTo-SecureString -String $Secrets[$key] -AsPlainText
                }
                else {
                    $Secrets[$key]
                }
                Set-Secret -Vault $script:vault.Name -Name $Key -SecureStringSecret $Secret -MetaData $Tag
                Write-Host "  $($key)" -ForegroundColor green
            }
            Write-Host $script:tick -ForegroundColor Yellow
        }
        else {
            "No Vault"
        }
    }
    catch {
        throw $_
    }
}