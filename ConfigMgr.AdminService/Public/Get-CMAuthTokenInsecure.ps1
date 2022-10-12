#Adding this function in to allow the ability to use the adminservice in cloud automation projects. It should be used very sparingly... :-)
function Get-CMAuthTokenInsecure {
    [cmdletbinding(DefaultParameterSetName = 'InsecureAuth')]
    param (
        [parameter(mandatory = $false, parametersetname = "InsecureAuth")]
        [string]$TenantId,
    
        [parameter(mandatory = $false, parametersetname = "InsecureAuth")]
        [string]$ClientID,
    
        [parameter(mandatory = $false, parametersetname = "InsecureAuth")]
        [string]$ServerAppIdUri,

        [parameter(mandatory = $false, parametersetname = "InsecureAuth")]
        [string]$Scope,

        [parameter(mandatory = $false, parametersetname = "InsecureAuth")]
        [string]$UserName,

        [SecureString]$Password
    )
    try {
        #Write-Host "Getting AuthToken " -ForegroundColor Cyan -NoNewline
        #LocalKeyVault
        if ($script:vault.Name) {
            $TenantId = if ($TenantId) { $TenantId } else { Get-Secret -Vault $script:vault.Name -Name "AdminServiceTenantID" -AsPlainText }
            $ClientID = if ($ClientID) { $ClientID } else { Get-Secret -Vault $script:vault.Name -Name "AdminServiceClientAppId" -AsPlainText }
            $ServerAppIdUri = if ($ServerAppIdUri) { $ServerAppIdUri } else { Get-Secret -Vault $script:vault.Name -Name "AdminServiceServerAppIdUri" -AsPlainText }
            $Scope = if ($Scope) { $Scope } else { Get-Secret -Vault $script:vault.Name -Name "AdminServiceClientAppScope" -AsPlainText }
            $UserName = if ($UserName) { $UserName } else { Get-Secret -Vault $script:vault.Name -Name "AdminServiceUserName" -AsPlainText }
            $Password = if ($Password) { $Password } else { Get-Secret -Vault $script:vault.Name -Name "AdminServicePassword" }
        }
        #AzureKeyVaultDirect
        elseif ($script:vault.VaultName) {
            $TenantId = if ($TenantId) { $TenantId } else { Get-AzKeyVaultSecret -VaultName $script:vault.VaultName -Name "AdminServiceTenantId" -AsPlainText }
            $ClientID = if ($ClientID) { $ClientID } else { Get-AzKeyVaultSecret -VaultName $script:vault.VaultName -Name "AdminServiceClientAppId" -AsPlainText }
            $ServerAppIdUri = if ($ServerAppIdUri) { $ServerAppIdUri } else { Get-AzKeyVaultSecret -VaultName $script:vault.VaultName -Name "AdminServiceServerAppIdUri" -AsPlainText }
            $Scope = if ($Scope) { $Scope } else { Get-AzKeyVaultSecret -VaultName $script:vault.VaultName -Name "AdminServiceClientAppScope" -AsPlainText }
            $UserName = if ($UserName) { $UserName } else { Get-AzKeyVaultSecret -VaultName $script:vault.VaultName -Name "AdminServiceUserName" -AsPlainText }
            $Password = if ($Password) { $Password } else { (Get-AzKeyVaultSecret -VaultName $script:vault.VaultName -Name "AdminServicePassword").SecretValue }
        }

        if ($username -and $Password) {
            $UserCredential = [pscredential]::new($Username, $Password)
        }

        #Since we are using MSAL and Rest, the token bodies are different so we will normalize the output
        $TokenObj = [PSCustomObject]@{
            AccessToken = $null
            ExpiresOn   = $null
        }

        if ($ServerAppIdUri -and (-not $Scope)) {
            $Scope = "$($ServerAppIdUri)/.default"
        }
        elseif (-not $Scope) {
            $Scope = "api://$($TenantId)/$($ServerAppId)/.default"
        }

        $RedirectUri = if ($RedirectUri) { $RedirectUri } else { "msal$($ClientId)://auth" }
        $params = @{
            TenantId       = $TenantID
            ClientId       = $ClientId
            Authority      = "https://login.windows.net/$($TenantId)"
            Scopes         = $Scope
            UserCredential = $UserCredential
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