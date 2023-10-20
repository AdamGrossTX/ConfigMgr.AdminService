function Invoke-CMDelete {
    [CmdletBinding()]
    param (
        [string]$URI,
        [string]$Token = $script:AdminServiceAuthToken.AccessToken,
        [switch]$ReturnErrorToCaller
    )
    try {
        #check if the token is using the secrets token and if so ensure it's current, otherwise refresh it
        if ($URI -like "*AdminService_TokenAuth*" -or $URI -like "*CCM_Proxy_ServerAuth*" -or $URI -like "*CCM_Proxy_MutualAuth*") {
            #check if the token is using the secrets token and if so ensure it's current, otherwise refresh it
            if ($Token) {
                #if ($Token -eq $script:AdminServiceAuthToken.AccessToken) {
                #if ((Get-Date) - ((Get-Date 01.01.1970) + ([System.TimeSpan]::fromseconds($script:AdminServiceAuthToken.ExpiresOn))) -ge 0) {
                #$Token = (Get-CMAuthToken).AccessToken
                #}
                #}
            }
            elseif (-not $script:AdminServiceAuthToken.AccessToken) {
                if (-not $script:AdminServiceTenantId) {
                    Get-CMSecrets
                }
                $Token = (Get-CMAuthToken).AccessToken
            }

            if ($Token) {

                $Params = @{
                    Headers     = @{
                        "Authorization" = "Bearer $($Token)"
                    }
                    Method      = "DELETE"
                    ContentType = "application/json"
                    URI         = $URI
                }
            }
            else {
                Write-Host "No Auth Token."
                return $null
            }
        }
        elseif($script:LocalAuthCreds) 
        {
            $Params = @{
                Method               = "DELETE"
                ContentType          = "application/json"
                URI                  = $URI
                Credential           = $script:LocalAuthCreds
            }
        }
        else
        {
            $Params = @{
                Method               = "DELETE"
                ContentType          = "application/json"
                URI                  = $URI
                UseDefaultCredential = $True
            }
        }

        Write-Verbose $URI
        $Result = Invoke-RestMethod @Params

        if (($Result | Get-Member).Name -eq "Value") {
            return $Result.value
        }
        else {
            return $Result
        }
    
    }
    catch [System.Net.WebException] {
        if ($ReturnErrorToCaller.IsPresent) {
            throw $_
        } 
        else {
            if ($_.ErrorDetails.Message) {
                $err = ($_.ErrorDetails.Message | ConvertFrom-JSON).Error
                Write-Host $err.Code, $err.Message -ForegroundColor Yellow
                Write-Host $_.Exception -ForegroundColor Yellow
                Write-Host $_.InvocationInfo.PositionMessage -ForegroundColor Yellow
            }
            else {
                Write-Host $_.Exception, $_.Exception.InvocationInfo.ScriptLineNumber -ForegroundColor Yellow
                Write-Host $_.InvocationInfo.PositionMessage -ForegroundColor Yellow
            }
            throw $_
        }
        catch {
            throw $_
        }
    }
}