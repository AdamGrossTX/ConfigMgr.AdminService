function Initialize-CMAdminService {
    [cmdletbinding(DefaultParameterSetName = 'UserAuth')]
    param(

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthCert")]
        [string]$AzureKeyVaultName,

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthCert")]
        [string]$LocalKeyVaultName,
        
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
        [parameter(mandatory = $false, parametersetname = "NoVault")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthThumb")]
        [parameter(mandatory = $false, parametersetname = "ServicePrincipalAuthCert")]
        [switch]$UseCMG,

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [switch]$UseInsecureAuth,

        [parameter(mandatory = $false, parametersetname = "UserAuth")]
        [parameter(mandatory = $false, parametersetname = "NoVault")]
        [switch]$UseAutomationIdentity
        
    )

    try {

        #LocalAuth - Requires AdminServiceProviderURL
        #          - Doesn't Use Key Vault
        
        #No Vault   - Requires Auth Token
        #           - Requires Auth Token Params
        #           - Requires AdminServiceProviderURL
        
        #TODO Add Logic to detect which parameterset you used
        [hashtable]$ResultObj = @{
            ASURI = $null
            ASVerURI = $null
            ASWmiURI = $null
            vault = $null
            AdminServiceAuthToken = $null
        }
        if ($AdminServiceProviderURL) {
            $script:ASURI = if ($AdminServiceProviderURL -notlike '*/') { $AdminServiceProviderURL + "/" } else { $AdminServiceProviderURL }
            $script:ASVerURI = "$($ASURI)v1.0/"
            $script:ASWmiURI = "$($ASURI)wmi/"
        }
        if ($UseLocalAuth.IsPresent) {
            Write-Output "Using Local Auth"
        }
        else {
            #NoVault
            if ($ClientID -and (-not $script:AdminServiceAuthToken -or $ReAuthAdminServiceToken)) {
                $script:AdminServiceAuthToken = Get-CMAuthToken -TenantId $TenantId -ClientID $ClientID -Resource $Resource -RedirectUri $RedirectUri
            }
            #Key vault
            else {
                #Service Principal Certificate Auth
                #TODO Check to see if already authed with the SP

                #Clear Auth to Key Vault if needed
                if ($ReAuthAzureKeyVault) {
                    Clear-AzContext -Force -Confirm:$False -ErrorAction SilentlyContinue
                }
                else {
                    $Context = Get-AzContext -ErrorAction SilentlyContinue
                }

                if (-not $Context.Subscription.id) {
                    if ($CertificateThumbprint -or $Certificate) {
                        $ServicePrincipalAuth = @{
                            TenantId              = $TenantId
                            ApplicationId         = $ApplicationId
                            CertificateThumbprint = if ($Certificate) { $Certificate.Thumbprint } else { $CertificateThumbprint }
                            ServicePrincipal      = $True
                        }
                        $connection = Connect-AzAccount @ServicePrincipalAuth | Out-Null
                    }
                    elseIf ($ClientSecret) {
                        $ServicePrincipalAuth = @{
                            TenantId         = $TenantId
                            ApplicationId    = $ApplicationId
                            ClientSecret     = $ClientSecret
                            ServicePrincipal = $True
                        }
                        $connection = Connect-AzAccount @ServicePrincipalAuth | Out-Null
                    }
                    elseif ($UseAutomationIdentity) {
                        $connection = Connect-AZAccount -Identity | Out-Null
                    }
                    else {
                        $connection = Connect-AzAccount | Out-Null
                    }
                } 

                $Context = Get-AzContext
                if(-Not $Context.Subscription.id) {
                    Write-Output "We didn't get connected."
                }

                $script:vault = Get-CMKeyVault -AzureKeyVaultName $AzureKeyVaultName

                $AdminServiceSecrets = if ($AzureKeyVaultName) {
                    Get-AzKeyVaultSecret -VaultName $AzureKeyVaultName -Name *AdminService* -ErrorAction SilentlyContinue
                }
                elseif ($LocalKeyVaultName) {
                    Get-SecretInfo -Vault $LocalKeyVaultName -Name *AdminService* -ErrorAction SilentlyContinue
                }
                else {
                    Write-Output "No Vault Found" 
                }

                if (-not $AdminServiceSecrets) {
                    Write-Output "Go Create Secrets" 
                }
                else {
                    if (-not $AdminServiceProviderURL) {
                        $URL = if ($UseCMG.IsPresent) {
                            if ($AzureKeyVaultName) {
                                Get-AzKeyVaultSecret -VaultName $script:vault.VaultName -Name "AdminServiceCMGURL" -AsPlainText
                            }
                            else {
                                Get-Secret -Vault $script:vault.Name -Name "AdminServiceCMGURL" -AsPlainText
                            }
                        }
                        else {
                            if ($AzureKeyVaultName) {
                                Get-AzKeyVaultSecret -VaultName $script:vault.VaultName -Name "AdminServiceBaseURL" -AsPlainText
                            }
                            else {
                                Get-Secret -Vault $script:vault.Name -Name "AdminServiceBaseURL" -AsPlainText
                            }
                        }

                        $script:ASURI = if ($URL -notlike '*/') { $URL + "/" } else { $URL }
                        $script:ASVerURI = "$($ASURI)v1.0/"
                        $script:ASWmiURI = "$($ASURI)wmi/"
                    }

                    if (-not $script:AdminServiceAuthToken -or $ReAuthAdminServiceToken) {
                        if ($UseInsecureAuth) {
                            $script:AdminServiceAuthToken = Get-CMAuthTokenInsecure
                        } 
                        else {
                            $script:AdminServiceAuthToken = Get-CMAuthToken
                        }
                    }
                    #Write-Verbose "AdminService Initialized. Using $($script:ASURI) for access." 
                }
            }
        }
        $ResultObj.ASWmiURI = $script:ASWmiURI
        $ResultObj.ASURI = $script:ASURI
        $ResultObj.ASVerURI = $script:ASVerURI
        $ResultObj.vault = $script:vault
        $ResultObj.AdminServiceAuthToken = $script:AdminServiceAuthToken
        return $ResultObj
    }
    catch {
        throw $_
    }
}