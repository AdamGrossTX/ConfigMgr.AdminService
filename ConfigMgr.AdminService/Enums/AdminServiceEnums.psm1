enum SourceType {
    SelfServicePortal = 1
    Administrator = 2
    User = 3
    UsageAgent = 4
    OSDDefined = 6
}

enum ClientAction {
    DownloadComputerPolicy = 8
    DownloadUserPolicy = 9
    CollectDiscoveryData = 10
    CollectSoftwareInventory = 11
    CollectHardwareInventory = 12
    EvaluateApplicationDeployments = 13
    EvaluateSoftwareUpdateDeployments = 14
    SwitchToNextSoftwareUpdatePoint = 15
    EvaluateDeviceHealthAttestation = 16
    CheckConditionalAccessCompliance = 125
    WakeUp = 150
    Restart = 17
    EnableVerboseLogging = 20
    DisableVerboseLogging = 21
    CollectClientLogs = 22
}

enum RelationshipType {
    MyComputers = 1
}

enum CollectionType {
    User = 1
    Device = 2
}