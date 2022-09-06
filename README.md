# ConfigMgr.AdminService Module

The purpose if this module is to provide PowerShell cmdlet access to the ConfigMgr Administration Service (AdminService). The module features secrets management using Azure Key Vault and support for Token Authentication for automation workloads. Additionally, the AdminService can be configured to be accessible via Azure Application Proxy which allows you to run commands without a direct connection to your ConfigMgr provider server.

## Prerequisites

I've built a lot of stuff out, but you'll have to do SOME legwork if you want to leverage Azure Key Vault or use AdminService over the internet.

- Azure Tenant with Subscription
- ConfigMgr Env with AdminService Enabled
- Cloud Management Gateway
- Azure App Proxy
- ConfigMgr Web App and Client App Registrations

### Key Vault with Cloud Management Gateway (CMG) or Azure App Proxy

```powershell
Install-Module ConfigMgr.AdminService
```

#### Azure Key Vault

```powershell
 New-CMKeyVault -TenantId bac71e12-25a3-4e40-b871-1896ef219357 -SubscriptionId 92812f8f-f4c8-4c99-8e9e-c8fa7d3e81b9 -Location "South Central US"

$Params = @{
    AdminServiceTenantId       = "bac71e12-25a3-4e40-b871-1896ef219357"
    AdminServiceBaseURL        = "https://adminservice.asquaredozen.com/AdminService_TokenAuth"
    AdminServiceCMGURL         = "HTTPS://ASDCMG.ASQUAREDOZEN.COM/CCM_Proxy_ServerAuth/72057594037927869/AdminService"
    AdminServiceClientAppId    = "b87d7ed1-7cd9-48a8-89af-f748bc6ce727"
    AdminServiceServerAppId    = "a0dbbd77-f01b-4c35-8aca-b8e14c084ece"
    AdminServiceServerAppIdUri = "api://bac71e12-25a3-4e40-b871-1896ef219357/a0dbbd77-f01b-4c35-8aca-b8e14c084ece"
}
Set-CMKeyVaultValues @Params
```

or

```powershell
$Params = @{
    TenantId             = "bac71e12-25a3-4e40-b871-1896ef219357"
    SubscriptionId       = "92812f8f-f4c8-4c99-8e9e-c8fa7d3e81b9"
    Location             = "South Central US"
    CreateDefaultSecrets = $true
    Secrets              = @{
        AdminServiceTenantId       = "bac71e12-25a3-4e40-b871-1896ef219357"
        AdminServiceBaseURL        = "https://adminservice.asquaredozen.com/AdminService_TokenAuth"
        AdminServiceCMGURL         = "HTTPS://ASDCMG.ASQUAREDOZEN.COM/CCM_Proxy_ServerAuth/72057594037927869/AdminService"
        AdminServiceClientAppId    = "b87d7ed1-7cd9-48a8-89af-f748bc6ce727"
        AdminServiceServerAppId    = "a0dbbd77-f01b-4c35-8aca-b8e14c084ece"
        AdminServiceServerAppIdUri = "api://bac71e12-25a3-4e40-b871-1896ef219357/a0dbbd77-f01b-4c35-8aca-b8e14c084ece"
    }
}
$vault = New-CMKeyVault @Params
```

#### Local Secrets Vault

```powershell
$vault = New-CMKeyVault -UseLocalVault

$Params = @{
    AdminServiceTenantId       = "bac71e12-25a3-4e40-b871-1896ef219357"
    AdminServiceBaseURL        = "https://adminservice.asquaredozen.com/AdminService_TokenAuth"
    AdminServiceCMGURL         = "HTTPS://ASDCMG.ASQUAREDOZEN.COM/CCM_Proxy_ServerAuth/72057594037927869/AdminService"
    AdminServiceClientAppId    = "b87d7ed1-7cd9-48a8-89af-f748bc6ce727"
    AdminServiceServerAppId    = "a0dbbd77-f01b-4c35-8aca-b8e14c084ece"
    AdminServiceServerAppIdUri = "api://bac71e12-25a3-4e40-b871-1896ef219357/a0dbbd77-f01b-4c35-8aca-b8e14c084ece"
}
Set-CMKeyVaultValues @Params
```

#### No Vault or Local Only

Not needed.

## Install the module

```powershell
Install-Module ConfigMgr.AdminService -Scope CurrentUser
```

## Initialize the Secrets

To launch the module and get secrets from the vault you'll need to supply the Azure Key Vault Name.

#### Current User Auth

```powershell
Initialize-CMAdminService
```

Or
#### Service Principal Auth

An Azure App Registration (Service Principal) is required and must have a certificate uploaded. Supply the certificate thumbprint to the function. The Service Principal will need permissions to the keyvault.

```powershell
Initialize-CMAdminService -AzureKeyVaultName "MyAzureKeyVault" -TenantId "{TenantId}" -ApplicationId "{TenantId}" -CertificateThumbprint "2J3H23KKDD4IJDJDIW34JWK3JK23M32KK3N23"
```

## Test these functions to get started

```powershell
#Get all devices
Get-CMDevice

#Get all users
Get-CMUser
```