function New-CMCollection {
    [cmdletbinding()]
    param (
        [string]$Name,
        [CollectionType]$Type = "Device",
        [string]$Comment = "",
        [string]$LimitToCollectionID = "SMS00001"
    )
    try {

        $Body = @{
            Name                = $Name
            LimitToCollectionID = $LimitToCollectionID
            Comment             = $Comment
            CollectionType      = $Type.Value__
        }

        $ExistingCollection = Get-CMCollection -Name $Name
        if ($ExistingCollection) {
            Write-Host "Another collection exists with the name $($Name). No collection created." -ForegroundColor Yellow
            Return $ExistingCollection | Select-Object -Property * -ExcludeProperty _*, `@odata*
        }
        else {
            $Result = Invoke-CMPost -URI "$($script:ASWmiURI)/SMS_Collection" -Body $Body
            Return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
        }
    }
    catch {
        throw $_
    }
}