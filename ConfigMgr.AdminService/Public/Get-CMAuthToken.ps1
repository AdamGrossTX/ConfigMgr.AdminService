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
        [string]$Scope
    )
    try {
        #Write-Host "Getting AuthToken " -ForegroundColor Cyan -NoNewline
        if ($script:vault) {
            $TenantId = if ($TenantId) { $TenantId } else { Get-Secret -Vault $script:vault.Name -Name "AdminServiceTenantID" -AsPlainText }
            $ClientID = if ($ClientID) { $ClientID } else { Get-Secret -Vault $script:vault.Name -Name "AdminServiceClientAppId" -AsPlainText }
            $ServerAppId = if ($ServerAppId) { $ServerAppId } else { Get-Secret -Vault $script:vault.Name -Name "AdminServiceServerAppId" -AsPlainText }
            $Scope = if ($Scope) { $Scope } else { Get-Secret -Vault $script:vault.Name -Name "AdminServiceClientAppScope" -AsPlainText }
        }
    
        #Since we are using MSAL and Rest, the token bodies are different so we will normalize the output
        $TokenObj = [PSCustomObject]@{
            AccessToken = $null
            ExpiresOn   = $null
        }

        #if ($UseAADAuth.IsPresent) {
        $Authority = "https://login.windows.net/$($TenantId)"
        if(-not $Scope) {
            $Scope = "api://$($TenantId)/$($ServerAppId)/.default"
        }
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
        #Write-Host $script:tick -ForegroundColor Yellow
        return $script:AdminServiceAuthToken
       
    }
    catch {
        Write-Host "An Error Occurred."
        Write-Host $_.Exception, $_.Exception.InvocationInfo.ScriptLineNumber -ForegroundColor Yellow
        Write-Host $_.InvocationInfo.PositionMessage -ForegroundColor Yellow
        throw $_
    }
}