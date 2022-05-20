function Initialize-CMAdminService {
    [cmdletbinding(DefaultParameterSetName = 'UserAuth')]
    param(

        [parameter(mandatory = $true, parametersetname = "UserAuth")]
        [parameter(mandatory = $true, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $true, parametersetname = "ServicePrincipalAuthCert")]
        [string]$AzureKeyVaultName,

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthCert")]
        [string]$LocalAZKeyVaultName = "AdminServiceKeyVault",
        
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
            #Azure Key vault
            elseif ($AzureKeyVaultName) {
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

                if ($Context.Subscription.Id) {
                    $VaultExists = Get-SecretVault -Name $LocalAZKeyVaultName -ErrorAction SilentlyContinue
                    if (-not $VaultExists) {
                        Register-SecretVault -Name $LocalAZKeyVaultName -ModuleName Az.KeyVault -VaultParameters @{ AZKVaultName = $AzureKeyVaultName; SubscriptionId = $Context.Subscription.Id } -AllowClobber
                    }

                    $AdminServiceSecrets = Get-SecretInfo -Vault $LocalAZKeyVaultName -Name AdminService* -ErrorAction SilentlyContinue
                    if (-not $AdminServiceSecrets) {
                        Write-Host "Please create the following secrets in your AzureKeyVault 'cause Adam is too lazy to write the function to create these for you 😎" -ForegroundColor Yellow
                        Write-Host " - AdminServiceBaseURL" -ForegroundColor Cyan
                        Write-Host " - AdminServiceClientId" -ForegroundColor Cyan
                        Write-Host " - AdminServiceResource" -ForegroundColor Cyan
                        Write-Host " - AdminServiceTenantId" -ForegroundColor Cyan
                        Write-Host " - AdminServiceUserName" -ForegroundColor Cyan
                        Write-Host " - AdminServicePassword" -ForegroundColor Cyan
                        Write-Host " - RedirectUri" -ForegroundColor Cyan
                    }
                    else {
                        if (-not $AdminServiceProviderURL) {
                            $URL = if($UseCMG.IsPresent) {
                                Get-Secret -Vault $LocalAZKeyVaultName -Name "AdminServiceCMGURL" -AsPlainText
                            }
                            else {
                                Get-Secret -Vault $LocalAZKeyVaultName -Name "AdminServiceBaseURL" -AsPlainText
                            }

                            $script:ASURI = if ($URL -notlike '*/') { $URL + "/" } else { $URL }
                            $script:ASVerURI = "$($ASURI)v1.0/"
                            $script:ASWmiURI = "$($ASURI)wmi/"
                        }
                        $script:LocalAZKeyVaultName = $LocalAZKeyVaultName
                        if (-not $script:AdminServiceAuthToken -or $ReAuthAdminServiceToken) {
                            $script:AdminServiceAuthToken = Get-CMAuthToken
                        }
                        Write-Host "AdminService Initialized. Using $($script:ASURI) for access." -ForegroundColor Cyan
                    }
                }
                else {
                    Write-Host "User doesn't have access to the Vault subscription. Add vault read access to the vault subscription for the user or service principal." -ForegroundColor Yellow
                }
            }
        }
    }
    catch {
        throw $_
    }
}