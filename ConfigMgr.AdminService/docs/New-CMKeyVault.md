---
external help file: ConfigMgr.AdminService-help.xml
Module Name: ConfigMgr.AdminService
online version:
schema: 2.0.0
---

# New-CMKeyVault

## SYNOPSIS
Set up Key vault and secrets for use with the module

## SYNTAX

### AzureKeyVault (Default)
```
New-CMKeyVault -TenantId <String> -SubscriptionId <String> -Location <String> [-AzureKeyVaultName <String>]
 [-ResourceGroupName <String>] [-LocalKeyVaultName <String>] [-Tag <Hashtable>] [<CommonParameters>]
```

### AzureKeyVaultWithDefaultSecrets
```
New-CMKeyVault -TenantId <String> -SubscriptionId <String> -Location <String> [-AzureKeyVaultName <String>]
 [-ResourceGroupName <String>] [-LocalKeyVaultName <String>] [-Tag <Hashtable>] [-CreateDefaultSecrets]
 -Secrets <Hashtable> [<CommonParameters>]
```

### LocalKeyVaultWithDefaultSecrets
```
New-CMKeyVault [-LocalKeyVaultName <String>] [-Tag <Hashtable>] [-UseLocalVault] [-CreateDefaultSecrets]
 -Secrets <Hashtable> [<CommonParameters>]
```

### LocalKeyVault
```
New-CMKeyVault [-LocalKeyVaultName <String>] [-Tag <Hashtable>] [-UseLocalVault] [<CommonParameters>]
```

## DESCRIPTION
Set up Key vault and secrets for use with the module

## EXAMPLES

### EXAMPLE 1
```
New-CMKeyVault -TenantId bac71e12-25a3-4e40-b871-1896ef219357 -SubscriptionId 92812f8f-f4c8-4c99-8e9e-c8fa7d3e81b9 -Location "South Central US"
```

## PARAMETERS

### -TenantId
Azure AD Tenant Id

```yaml
Type: String
Parameter Sets: AzureKeyVault, AzureKeyVaultWithDefaultSecrets
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionId
Azure AD SubscriptionId where the KeyVault will be located

```yaml
Type: String
Parameter Sets: AzureKeyVault, AzureKeyVaultWithDefaultSecrets
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
DisplayName of Azure Location.
Use 

Get-AzLocation | Select-Object displayname

to find a location

```yaml
Type: String
Parameter Sets: AzureKeyVault, AzureKeyVaultWithDefaultSecrets
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AzureKeyVaultName
Custom key vault name.
Default is kvAdminService

```yaml
Type: String
Parameter Sets: AzureKeyVault, AzureKeyVaultWithDefaultSecrets
Aliases:

Required: False
Position: Named
Default value: KvAdminService
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Custom resource group name.
Default is rgAdminService

```yaml
Type: String
Parameter Sets: AzureKeyVault, AzureKeyVaultWithDefaultSecrets
Aliases:

Required: False
Position: Named
Default value: RgAdminService
Accept pipeline input: False
Accept wildcard characters: False
```

### -LocalKeyVaultName
Custom local vault name.
Default is kvAdminService

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: KvAdminService
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
HASHTABLE of values used to tag vault and secrets for easy access.
Default is

@{Project="ConfigMgr.AdminService"}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @{Project = "ConfigMgr.AdminService" }
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseLocalVault
Use a local key vault instead of Azure Key Vault

```yaml
Type: SwitchParameter
Parameter Sets: LocalKeyVaultWithDefaultSecrets, LocalKeyVault
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateDefaultSecrets
Create default secrets required for the AdminService KeyVault

```yaml
Type: SwitchParameter
Parameter Sets: AzureKeyVaultWithDefaultSecrets, LocalKeyVaultWithDefaultSecrets
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Secrets
Hashtable of secrets

```yaml
Type: Hashtable
Parameter Sets: AzureKeyVaultWithDefaultSecrets, LocalKeyVaultWithDefaultSecrets
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

## OUTPUTS

## NOTES
General notes

## RELATED LINKS
