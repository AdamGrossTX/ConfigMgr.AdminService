---
external help file: ConfigMgr.AdminService-help.xml
Module Name: ConfigMgr.AdminService
online version:
schema: 2.0.0
---

# New-CMUserMachineRelationship

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
New-CMUserMachineRelationship [[-MachineResourceId] <UInt32>] [[-UserAccountName] <String>]
 [[-SourceType] <SourceType>] [[-TypeId] <RelationshipType>] [-RemoveThisSourceOnly] [-RemoveAllOtherSources]
 [-RemoveAllExisting] [<CommonParameters>]
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

### -MachineResourceId
{{ Fill MachineResourceId Description }}

```yaml
Type: UInt32
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveAllExisting
{{ Fill RemoveAllExisting Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveAllOtherSources
{{ Fill RemoveAllOtherSources Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveThisSourceOnly
{{ Fill RemoveThisSourceOnly Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceType
{{ Fill SourceType Description }}

```yaml
Type: SourceType
Parameter Sets: (All)
Aliases:
Accepted values: SelfServicePortal, Administrator, User, UsageAgent, OSDDefined

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeId
{{ Fill TypeId Description }}

```yaml
Type: RelationshipType
Parameter Sets: (All)
Aliases:
Accepted values: MyComputers

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserAccountName
{{ Fill UserAccountName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
