<# 
There seems to be a bug with this one. Just going to loop through single adds for now.
#>
function Add-CMCollectionRules {
    [cmdletbinding(DefaultParameterSetName = "CollectionId")]
    param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $true, ParameterSetName = "Collection")]
        [Object]$Collection,

        [Parameter(Mandatory = $True, ValueFromPipeline = $true, ParameterSetName = "CollectionId")]
        [string]$CollectionId,
        
        [Parameter(Mandatory = $True)]
        [hashtable[]]$CollectionRule
    )

    PROCESS {
        try {

            $Body = @{
                collectionRules = $CollectionRule    
            }
            if ($Collection) {
                $CollectionId = $Collection.CollectionID
            }

            $Result = Invoke-CMPost -URI "$($script:ASWmiURI)SMS_Collection('$($CollectionID)')/AdminService.AddMembershipRules" -Body $Body
            Return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
        }
        catch {
            throw $_
        }
    }
}