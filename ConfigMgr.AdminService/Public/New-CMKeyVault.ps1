function New-CMKeyVault {
    [cmdletbinding(DefaultParameterSetName = "AzureKeyVault")]
    param (
        [parameter(mandatory = $true, ParameterSetName = "AzureKeyVault")]
        [parameter(mandatory = $true, ParameterSetName = "AzureKeyVaultWithDefaultSecrets")]
        [string]$TenantId,
        
        [parameter(mandatory = $true, ParameterSetName = "AzureKeyVault")]
        [parameter(mandatory = $true, ParameterSetName = "AzureKeyVaultWithDefaultSecrets")]
        [string]$SubscriptionId,

        [parameter(mandatory = $true, ParameterSetName = "AzureKeyVault")]
        [parameter(mandatory = $true, ParameterSetName = "AzureKeyVaultWithDefaultSecrets")]
        [string]$Location,
        
        [parameter(mandatory = $false, ParameterSetName = "AzureKeyVault")]
        [parameter(mandatory = $false, ParameterSetName = "AzureKeyVaultWithDefaultSecrets")]
        [string]$AzureKeyVaultName = "kvAdminService",
        
        [parameter(mandatory = $false, ParameterSetName = "AzureKeyVault")]
        [parameter(mandatory = $false, ParameterSetName = "AzureKeyVaultWithDefaultSecrets")]
        [string]$ResourceGroupName = "rgAdminService",

        [parameter(mandatory = $false, ParameterSetName = "AzureKeyVault")]
        [parameter(mandatory = $false, ParameterSetName = "LocalKeyVault")]
        [parameter(mandatory = $false, ParameterSetName = "LocalKeyVaultWithDefaultSecrets")]
        [parameter(mandatory = $false, ParameterSetName = "AzureKeyVaultWithDefaultSecrets")]
        [string]$LocalKeyVaultName = "kvAdminService",

        [parameter(mandatory = $false, ParameterSetName = "AzureKeyVault")]
        [parameter(mandatory = $false, ParameterSetName = "LocalKeyVault")]
        [parameter(mandatory = $false, ParameterSetName = "LocalKeyVaultWithDefaultSecrets")]
        [parameter(mandatory = $false, ParameterSetName = "AzureKeyVaultWithDefaultSecrets")]
        [hashtable]$Tag = @{Project = "ConfigMgr.AdminService" },

        [parameter(mandatory = $true, ParameterSetName = "LocalKeyVault")]
        [parameter(mandatory = $true, ParameterSetName = "LocalKeyVaultWithDefaultSecrets")]
        [switch]$UseLocalVault,
        
        [parameter(mandatory = $true, ParameterSetName = "LocalKeyVaultWithDefaultSecrets")]
        [parameter(mandatory = $true, ParameterSetName = "AzureKeyVaultWithDefaultSecrets")]
        [switch]$CreateDefaultSecrets,

        [parameter(mandatory = $true, ParameterSetName = "LocalKeyVaultWithDefaultSecrets")]
        [parameter(mandatory = $true, ParameterSetName = "AzureKeyVaultWithDefaultSecrets")]
        [hashtable]$Secrets
    )

    try {
        if ($tag) {
            $script:Tag = $Tag
        }
        
        Get-CMKeyVault | Out-Null

        if ($UseLocalVault.IsPresent) {
            if (-not ($script:vault.ModuleName -eq "Microsoft.PowerShell.SecretStore")) {
                Write-Host "Creating Local Key Vault $($LocalKeyVaultName)." -ForegroundColor Cyan -NoNewline
                $VaultParams = @{}
                #Add custom tags to key vault to find it later
                foreach ($key in $script:tag.keys) {
                    $VaultParams[$key] = $script:tag[$key]
                }
                Register-SecretVault -Name $LocalKeyVaultName -ModuleName "Microsoft.PowerShell.SecretStore" -VaultParameters $VaultParams -AllowClobber
                Write-Host $script:tick -ForegroundColor Yellow
                $script:vault = Get-SecretVault -Name $LocalKeyVaultName -ErrorAction SilentlyContinue
            }
        }
        elseif (-not ($script:vault.ModuleName -eq "Az.KeyVault")) {
            if (-not (Get-Module -Name Az.KeyVault -ListAvailable)) {
                Install-Module Az.KeyVault
            }
            Import-Module Az.KeyVault
    
            Clear-AzContext -Force -Confirm:$False -ErrorAction SilentlyContinue

            Write-Host "Connecting to Azure Account. Log in with Account with rights to create a Resource Group and Key Vault." -ForegroundColor Cyan -NoNewline
            Connect-AzAccount -Tenant $TenantId -Subscription $SubscriptionId | Out-Null
            Write-Host $script:tick -ForegroundColor Yellow

            $ResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -Location $Location -ErrorAction SilentlyContinue
            if (-not $ResourceGroup) {
                Write-Host "Creating Resource Group $($ResourceGroupName)." -ForegroundColor Cyan -NoNewline
                $ResourceGroup = New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag $script:Tag
                Write-Host $script:tick -ForegroundColor Yellow
            }

            $Vault = Get-AZKeyVault -VaultName $AzureKeyVaultName -ResourceGroupName $ResourceGroup.ResourceGroupName -ErrorAction SilentlyContinue
            if (-not $Vault) {
                Write-Host "Creating Azure Key Vault $($AzureKeyVaultName)." -ForegroundColor Cyan -NoNewline
                $Vault = New-AzKeyVault -Name $AzureKeyVaultName -ResourceGroupName $ResourceGroupName -Tag $script:Tag -Location $Location
                Write-Host $script:tick -ForegroundColor Yellow
            }

            $Context = Get-AzContext -ErrorAction SilentlyContinue
            if ($Context.Subscription.Id) {
                Write-Host "Connecting Azure Key Vault to Local Secret Vault " -ForegroundColor Cyan -NoNewline

                $VaultParams = @{
                    AZKVaultName   = $AzureKeyVaultName
                    SubscriptionId = $Context.Subscription.Id
                    ResourceGroup  = $ResourceGroupName
                }
                #Add custom tags to key vault to find it later
                foreach ($key in $script:tag.keys) {
                    $VaultParams[$key] = $script:tag[$key]
                }
                Register-SecretVault -Name $LocalKeyVaultName -ModuleName Az.KeyVault -VaultParameters $VaultParams -AllowClobber
                Write-Host $script:tick -ForegroundColor Yellow
                $script:vault = Get-SecretVault -Name $LocalKeyVaultName -ErrorAction SilentlyContinue
            }
        }

        if ($CreateDefaultSecrets) {
            Set-CMKeyVaultValues -Secrets $Secrets
        }
        
        return $script:vault
    }
    catch {
        throw $_
    }
}