---
external help file: ConfigMgr.AdminService-help.xml
Module Name: ConfigMgr.AdminService
online version:
schema: 2.0.0
---

# Set-CMKeyVaultValues

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### DefaultSecrets (Default)
```
Set-CMKeyVaultValues -AdminServiceTenantId <String> [-Tag <Hashtable>] -AdminServiceBaseURL <String>
 -AdminServiceCMGURL <String> -AdminServiceClientAppId <String> -AdminServiceServerAppId <String>
 -AdminServiceServerAppIdUri <String> [-ReAuthAzureKeyVault <Object>] [<CommonParameters>]
```

### CustomSecrets
```
Set-CMKeyVaultValues [-Tag <Hashtable>] -Secrets <Hashtable> [-ReAuthAzureKeyVault <Object>]
 [<CommonParameters>]
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

### -AdminServiceBaseURL
{{ Fill AdminServiceBaseURL Description }}

```yaml
Type: String
Parameter Sets: DefaultSecrets
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdminServiceCMGURL
{{ Fill AdminServiceCMGURL Description }}

```yaml
Type: String
Parameter Sets: DefaultSecrets
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdminServiceClientAppId
{{ Fill AdminServiceClientAppId Description }}

```yaml
Type: String
Parameter Sets: DefaultSecrets
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdminServiceServerAppId
{{ Fill AdminServiceServerAppId Description }}

```yaml
Type: String
Parameter Sets: DefaultSecrets
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdminServiceServerAppIdUri
{{ Fill AdminServiceServerAppIdUri Description }}

```yaml
Type: String
Parameter Sets: DefaultSecrets
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdminServiceTenantId
{{ Fill AdminServiceTenantId Description }}

```yaml
Type: String
Parameter Sets: DefaultSecrets
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReAuthAzureKeyVault
{{ Fill ReAuthAzureKeyVault Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Secrets
{{ Fill Secrets Description }}

```yaml
Type: Hashtable
Parameter Sets: CustomSecrets
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
Parameter Sets: (All)
Aliases:

Required: False
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
