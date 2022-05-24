---
external help file: ConfigMgr.AdminService-help.xml
Module Name: ConfigMgr.AdminService
online version:
schema: 2.0.0
---

# Invoke-CMClientAction

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Invoke-CMClientAction [[-TargetResourceIDs] <UInt32[]>] [[-Type] <ClientAction>]
 [[-RandomizationWindow] <UInt32>] [[-TargetCollectionID] <String>] [<CommonParameters>]
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

### -RandomizationWindow
{{ Fill RandomizationWindow Description }}

```yaml
Type: UInt32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetCollectionID
{{ Fill TargetCollectionID Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetResourceIDs
{{ Fill TargetResourceIDs Description }}

```yaml
Type: UInt32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
{{ Fill Type Description }}

```yaml
Type: ClientAction
Parameter Sets: (All)
Aliases:
Accepted values: DownloadComputerPolicy, DownloadUserPolicy, CollectDiscoveryData, CollectSoftwareInventory, CollectHardwareInventory, EvaluateApplicationDeployments, EvaluateSoftwareUpdateDeployments, SwitchToNextSoftwareUpdatePoint, EvaluateDeviceHealthAttestation, Restart, EnableVerboseLogging, DisableVerboseLogging, CollectClientLogs, CheckConditionalAccessCompliance, WakeUp

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
