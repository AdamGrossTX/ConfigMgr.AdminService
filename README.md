# ConfigMgr.AdminService Module

The purpose if this module is to provide PowerShell cmdlet access to the ConfigMgr Administration Service (AdminService). The module features secrets management using Azure Key Vault and support for Token Authentication for automation workloads. Additionally, the AdminService can be configured to be accessible via Azure Application Proxy which allows you to run commands without a direct connection to your ConfigMgr provider server.

## Setup

I've built a lot of stuff out, but you'll have to do SOME legwork if you want to leverage Azure Key Vault or use AdminService over the internet.

### App Registration

### Azure Key Vault

### Create the following Secrets

```plaintext
AdminServiceBaseURL
Description: Azure Application Proxy URL
SecretName: AdminServiceBaseURL
SecretValue: https://adminservice.contoso.com/AdminService_TokenAuth/

Description: On-prem URL
SecretName: AdminServiceBaseURL
SecretValue: https://smsproviderservername.mydomain.internal/AdminService/

AdminServiceClientId
Description: The ClientId of the Azure App Registration used to access the AdminService Server App Registration
SecretName: 
SecretValue: {ApplicationIdGUID}

AdminServiceBaseURL
Description: The **Application ID URI** of the ConfigMgr Cloud Management App Registration
SecretName: AdminServiceBaseURL
SecretValue: api://{TenantID}/{ApplicationClientID}

AdminServiceTenantId
Description: The Azure TenantId of the Azure App Registration
SecretName: AdminServiceTenantId
SecretValue: {TenantID}

AdminServiceUserName
Description: The UPN of the account that has access Admin access to manage ConfigMgr
SecretName: AdminServiceUserName
SecretValue: MyUser@MyDomain.com

AdminServicePassword
Description: The Password of the account that has access Admin access to manage ConfigMgr
SecretName: AdminServicePassword
SecretValue: MySuperSecretPassword
```

## Install the module

```powershell
Install-Module ConfigMgr.AdminService -Scope CurrentUser
```

## Initialize the Secrets

To launch the module and get secrets from the vault you'll need to supply the Azure Key Vault Name.

#### Current User Auth

```powershell
Initialize-CMAdminService -KeyVaultName "MyKeyVaultName"
```

Or
#### Service Principal Auth

An Azure App Registration (Service Principal) is required and must have a certificate uploaded. Supply the certificate thumbprint to the function. The Service Principal will need permissions to the keyvault.

```powershell
Initialize-CMAdminService -AzureKeyVaultName "MyAzureKeyVault" -TenantId "{TenantId}" -ApplicationId "{TenantId}" -CertificateThumbprint "2J3H23KKDD4IJDJDIW34JWK3JK23M32KK3N23"
```

## Functions

```powershell
#Get all devices
Get-CMDevice

#Get all users
Get-CMUser
```
