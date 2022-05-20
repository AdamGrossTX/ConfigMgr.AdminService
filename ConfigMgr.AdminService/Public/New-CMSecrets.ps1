function New-CMSecrets {
    param (
        [string]$KeyVaultName,
        [string]$ApplicationId,
        [string]$CertificateThumbprint,
        [string]$TenantId,
        [string]$BaseURL,
        [string]$ClientId,
        [securestring]$Password,
        [string]$Resource,
        [string]$UserName
    )

    Install-Module Az.KeyVault -Force
    
    Connect-AzAccount -Tenant $TenantId -CertificateThumbprint $CertificateThumbprint -ApplicationId $ApplicationId

    Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name "AdminServiceBaseURL" -SecretValue (ConvertTo-SecureString -String $BaseURL -AsPlainText)
    Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name "AdminServiceCMGURL" -SecretValue (ConvertTo-SecureString -String $BaseURL -AsPlainText)
    Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name "AdminServiceClientId" -SecretValue (ConvertTo-SecureString -String $ClientId -AsPlainText)
    Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name "AdminServiceResourceId" -SecretValue (ConvertTo-SecureString -String $Resource -AsPlainText)
    Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name "AdminServiceTenantId" -SecretValue (ConvertTo-SecureString -String $TenantId -AsPlainText)
    Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name "AdminServiceUserName" -SecretValue (ConvertTo-SecureString -String $UserName -AsPlainText)
    Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name "AdminServicePassword" -SecretValue $Password
}