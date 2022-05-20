function Get-CMAuthToken {
    [cmdletbinding(DefaultParameterSetName = 'AADAuth')]
    param (
        [parameter(mandatory = $false, parametersetname = "AADAuth")]
        [string]$TenantId,
    
        [parameter(mandatory = $false, parametersetname = "AADAuth")]
        [string]$ClientID,
    
        [parameter(mandatory = $false, parametersetname = "AADAuth")]
        [string]$ServerAppId,
    
        [parameter(mandatory = $false, parametersetname = "AADAuth")]
        [string]$LocalAZKeyVaultName = $Script:LocalAZKeyVaultName
        
    )
    try {
        Write-Host "Getting AuthToken " -ForegroundColor Cyan -NoNewline
        if ($LocalAZKeyVaultName) {
            $TenantId = if ($TenantId) { $TenantId } else { Get-Secret -Vault $LocalAZKeyVaultName -Name "AdminServiceTenantID" -AsPlainText }
            $ClientID = if ($ClientID) { $ClientID } else { Get-Secret -Vault $LocalAZKeyVaultName -Name "AdminServiceClientId" -AsPlainText }
            $ServerAppId = if ($ServerAppId) { $ServerAppId } else { Get-Secret -Vault $LocalAZKeyVaultName -Name "AdminServiceServerAppId" -AsPlainText }
        }
    
        #Since we are using MSAL and Rest, the token bodies are different so we will normalize the output
        $TokenObj = [PSCustomObject]@{
            AccessToken = $null
            ExpiresOn   = $null
        }

        #if ($UseAADAuth.IsPresent) {
        $Authority = "https://login.windows.net/$($TenantId)"
        $Scope = "api://$($TenantId)/$($ServerAppId)/.default"
        $RedirectUri = if ($RedirectUri) { $RedirectUri } else { "msal$($ClientId)://auth" }

        $Params = @{
            ClientId    = $ClientID
            Authority   = $Authority
            RedirectUri = $RedirectUri
            Scopes      = $Scope
            TenantId    = $TenantId
            Interactive = $True
        }

        $TokenResponse = Get-MsalToken @Params
        $TokenObj.AccessToken = $TokenResponse.AccessToken
        $TokenObj.ExpiresOn = $TokenResponse.ExpiresOn

        $script:AdminServiceAuthToken = $TokenObj
        Write-Host $script:tick -ForegroundColor Yellow
        return $script:AdminServiceAuthToken
       
    }
    catch {
        Write-Host "An Error Occurred."
        Write-Host $_.Exception, $_.Exception.InvocationInfo.ScriptLineNumber -ForegroundColor Yellow
        Write-Host $_.InvocationInfo.PositionMessage -ForegroundColor Yellow
        throw $_
    }
}