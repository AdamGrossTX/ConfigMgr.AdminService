---
external help file: ConfigMgr.AdminService-help.xml
Module Name: ConfigMgr.AdminService
online version:
schema: 2.0.0
---

# Initialize-CMAdminService

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### UserAuth (Default)
```
Initialize-CMAdminService [-AzureKeyVaultName <String>] [-LocalKeyVaultName <String>]
 [-AdminServiceProviderURL <String>] [-Tag <Hashtable>] [-ReAuthAzureKeyVault] [-ReAuthAdminServiceToken]
 [-UseCMG] [<CommonParameters>]
```

### ServicePrincipalAuthCert
```
Initialize-CMAdminService [-AzureKeyVaultName <String>] [-LocalKeyVaultName <String>] -TenantId <String>
 -ApplicationId <String> -Certificate <X509Certificate> [-Tag <Hashtable>] [-ReAuthAzureKeyVault]
 [-ReAuthAdminServiceToken] [-UseCMG] [<CommonParameters>]
```

### ServicePrincipalAuthThumb
```
Initialize-CMAdminService [-AzureKeyVaultName <String>] [-LocalKeyVaultName <String>] -TenantId <String>
 -ApplicationId <String> -CertificateThumbprint <Object> [-Tag <Hashtable>] [-ReAuthAzureKeyVault]
 [-ReAuthAdminServiceToken] [-UseCMG] [<CommonParameters>]
```

### NoVault
```
Initialize-CMAdminService -TenantId <String> -AdminServiceProviderURL <String> -ClientID <String>
 -Resource <String> -RedirectUri <String> [-ReAuthAdminServiceToken] [<CommonParameters>]
```

### LocalAuth
```
Initialize-CMAdminService -AdminServiceProviderURL <String> [-UseLocalAuth] [<CommonParameters>]
```

### ServicePrincipalAuth
```
Initialize-CMAdminService [-AdminServiceProviderURL <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AdminServiceProviderURL
{{ Fill AdminServiceProviderURL Description }}

```yaml
Type: String
Parameter Sets: UserAuth, ServicePrincipalAuth
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: NoVault, LocalAuth
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicationId
{{ Fill ApplicationId Description }}

```yaml
Type: String
Parameter Sets: ServicePrincipalAuthCert, ServicePrincipalAuthThumb
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AzureKeyVaultName
{{ Fill AzureKeyVaultName Description }}

```yaml
Type: String
Parameter Sets: UserAuth, ServicePrincipalAuthCert, ServicePrincipalAuthThumb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Certificate
{{ Fill Certificate Description }}

```yaml
Type: X509Certificate
Parameter Sets: ServicePrincipalAuthCert
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CertificateThumbprint
{{ Fill CertificateThumbprint Description }}

```yaml
Type: Object
Parameter Sets: ServicePrincipalAuthThumb
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientID
{{ Fill ClientID Description }}

```yaml
Type: String
Parameter Sets: NoVault
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LocalKeyVaultName
{{ Fill LocalKeyVaultName Description }}

```yaml
Type: String
Parameter Sets: UserAuth, ServicePrincipalAuthCert, ServicePrincipalAuthThumb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReAuthAdminServiceToken
{{ Fill ReAuthAdminServiceToken Description }}

```yaml
Type: SwitchParameter
Parameter Sets: UserAuth, ServicePrincipalAuthCert, ServicePrincipalAuthThumb, NoVault
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReAuthAzureKeyVault
{{ Fill ReAuthAzureKeyVault Description }}

```yaml
Type: SwitchParameter
Parameter Sets: UserAuth, ServicePrincipalAuthCert, ServicePrincipalAuthThumb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RedirectUri
{{ Fill RedirectUri Description }}

```yaml
Type: String
Parameter Sets: NoVault
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Resource
{{ Fill Resource Description }}

```yaml
Type: String
Parameter Sets: NoVault
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
{{ Fill Tag Description }}

```yaml
Type: Hashtable
Parameter Sets: UserAuth, ServicePrincipalAuthCert, ServicePrincipalAuthThumb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantId
{{ Fill TenantId Description }}

```yaml
Type: String
Parameter Sets: ServicePrincipalAuthCert, ServicePrincipalAuthThumb, NoVault
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseCMG
{{ Fill UseCMG Description }}

```yaml
Type: SwitchParameter
Parameter Sets: UserAuth, ServicePrincipalAuthCert, ServicePrincipalAuthThumb
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseLocalAuth
{{ Fill UseLocalAuth Description }}

```yaml
Type: SwitchParameter
Parameter Sets: LocalAuth
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
