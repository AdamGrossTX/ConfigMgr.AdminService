<#
.NOTES
This only works in the more recent builds (2110+)
#>
function Add-CMCollectionRule {
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
            if ($Collection) {
                $CollectionId = $Collection.CollectionID
            }

            $Result = foreach ($Rule in $CollectionRule) {
                Invoke-CMPost -URI "$($script:ASWmiURI)SMS_Collection('$($CollectionID)')/AdminService.AddMembershipRule" -Body $Rule
            }
            Return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
        }
        catch {
            throw $_
        }
    }
}