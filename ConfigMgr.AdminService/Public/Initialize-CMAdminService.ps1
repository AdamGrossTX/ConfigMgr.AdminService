function Initialize-CMAdminService {
    [cmdletbinding(DefaultParameterSetName = 'UserAuth')]
    param(

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthCert")]
        [string]$AzureKeyVaultName = "kvAdminService",

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthCert")]
        [string]$LocalKeyVaultName = "kvAdminService",
        
        [parameter(mandatory = $true, parametersetname = "NoVault")]
        [parameter(mandatory = $true, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $true, parametersetname = "ServicePrincipalAuthCert")]
        [string]$TenantId,

        [parameter(mandatory = $true, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $true, parametersetname = "ServicePrincipalAuthCert")]
        [string]$ApplicationId,
        
        [parameter(mandatory = $true, parametersetname = "ServicePrincipalAuthThumb")]
        $CertificateThumbprint,

        [parameter(mandatory = $true, parametersetname = "ServicePrincipalAuthCert")]
        [X509Certificate]$Certificate,

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuth")]
        [parameter(mandatory = $true, parametersetname = "LocalAuth")]
        [parameter(mandatory = $true, parametersetname = "NoVault")]
        [string]$AdminServiceProviderURL,

        [parameter(mandatory = $true, parametersetname = "NoVault")]
        [string]$ClientID,
        
        [parameter(mandatory = $true, parametersetname = "NoVault")]
        [string]$Resource,
        
        [parameter(mandatory = $true, parametersetname = "NoVault")]
        [string]$RedirectUri,

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthCert")]
        [hashtable]$Tag = @{Project = "AdminService" },

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthCert")]
        [switch]$ReAuthAzureKeyVault,

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthCert")]
        [parameter(mandatory = $false, parametersetname = "NoVault")]
        [switch]$ReAuthAdminServiceToken,

        [parameter(mandatory = $true, parametersetname = "LocalAuth")]
        [switch]$UseLocalAuth,

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthCert")]
        [switch]$UseCMG
    )

    try {

        #LocalAuth - Requires AdminServiceProviderURL
        #          - Doesn't Use Key Vault
        
        #No Vault   - Requires Auth Token
        #           - Requires Auth Token Params
        #           - Requires AdminServiceProviderURL
        
        #TODO Add Logic to detect which parameterset you used
        Get-CMKeyVault | Out-Null
        
        if ($AdminServiceProviderURL) {
            $script:ASURI = if ($AdminServiceProviderURL -notlike '*/') { $AdminServiceProviderURL + "/" } else { $AdminServiceProviderURL }
            $script:ASVerURI = "$($ASURI)v1.0/"
            $script:ASWmiURI = "$($ASURI)wmi/"
        }
        if ($UseLocalAuth) {
            Write-Host "Using Local Auth"
        }
        else {
            #NoVault
            if ($ClientID) {
                if (-not $script:AdminServiceAuthToken -or $ReAuthAdminServiceToken) {
                    $script:AdminServiceAuthToken = Get-CMAuthToken -TenantId $TenantId -ClientID $ClientID -Resource $Resource -RedirectUri $RedirectUri
                }
            }
            #Key vault
            else {
                #Service Principal Certificate Auth
                #TODO Check to see if already authed with the SP

                #Clear Auth to Key Vault if needed
                if ($ReAuthAzureKeyVault) {
                    Clear-AzContext -Force -Confirm:$False -ErrorAction SilentlyContinue
                }
            
                $Context = Get-AzContext -ErrorAction SilentlyContinue

                if (-not $Context.Subscription.id) {
                    if ($CertificateThumbprint -or $Certificate) {
                        $ServicePrincipalAuth = @{
                            TenantId              = $TenantId
                            ApplicationId         = $ApplicationId
                            CertificateThumbprint = if ($Certificate) { $Certificate.Thumbprint } else { $CertificateThumbprint }
                            ServicePrincipal      = $True
                        }
                        Connect-AzAccount @ServicePrincipalAuth | Out-Null
                        #Connect-AzAccount returns context but the format is different than Get-AzContext so we are calling 
                        #Get-AzContext here to ensure it's the same format for the next steps
                        $Context = Get-AzContext -ErrorAction SilentlyContinue
                    }
            
                    elseIf ($ClientSecret) {

                        $ServicePrincipalAuth = @{
                            TenantId         = $TenantId
                            ApplicationId    = $ApplicationId
                            ClientSecret     = $ClientSecret
                            ServicePrincipal = $True
                        }
                
                        Connect-AzAccount @ServicePrincipalAuth | Out-Null
                        #Connect-AzAccount returns context but the format is different than Get-AzContext so we are calling 
                        #Get-AzContext here to ensure it's the same format for the next steps
                        $Context = Get-AzContext -ErrorAction SilentlyContinue
                    }
                    else {
                        Connect-AzAccount | Out-Null
                        $Context = Get-AzContext -ErrorAction SilentlyContinue
                    }
                } 

                <#
                if($UseLocalVault) {
                    $script:LocalVault = Get-SecretVault -Name $LocalKeyVaultName
                    if(-not $script:LocalVault) {
                        Write-Host "No local vault found. Please set up a new local vault." -ForegroundColor Yellow
                        return
                    }
                }
                else {
                    $LocalVaults = Get-SecretVault | Where-Object {$_.ModuleName -eq "Az.KeyVault"}
                    forEach($Vault in $LocalVaults) {
                        $AzVault = Get-AZKeyVault -VaultName $Vault.VaultParameters.AZKVaultName -SubscriptionId $Vault.VaultParameters.SubscriptionId -Tag $Tag -ErrorAction SilentlyContinue
                        if($AzVault) {
                            Write-Host "Found AdminService AzureKeyVault $($AzVault.VaultName)." -ForegroundColor cyan
                            $script:LocalVault = $Vault
                        }
                    }
                    if(-not $script:LocalVault) {
                        Write-Host "No vault found. Please run New-CMKeyVault to configure a new vault." -ForegroundColor Yellow
                        return
                    }
                }
#>
                $AdminServiceSecrets = Get-SecretInfo -Vault $LocalKeyVaultName -Name *AdminService* -ErrorAction SilentlyContinue
                if (-not $AdminServiceSecrets) {
                    Write-Host "Go Create Secrets" -ForegroundColor Yellow
                }
                else {
                    if (-not $AdminServiceProviderURL) {
                        $URL = if ($UseCMG.IsPresent) {
                            Get-Secret -Vault $script:vault.Name -Name "AdminServiceCMGURL" -AsPlainText
                        }
                        else {
                            Get-Secret -Vault $script:vault.Name -Name "AdminServiceBaseURL" -AsPlainText
                        }

                        $script:ASURI = if ($URL -notlike '*/') { $URL + "/" } else { $URL }
                        $script:ASVerURI = "$($ASURI)v1.0/"
                        $script:ASWmiURI = "$($ASURI)wmi/"
                    }

                    if (-not $script:AdminServiceAuthToken -or $ReAuthAdminServiceToken) {
                        $script:AdminServiceAuthToken = Get-CMAuthToken
                    }
                    Write-Host "AdminService Initialized. Using $($script:ASURI) for access." -ForegroundColor Cyan
                }
            }
            
        }
        
    }
    catch {
        throw $_
    }
}