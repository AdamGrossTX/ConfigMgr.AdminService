function New-CMScript {
    [cmdletbinding()]
    param (
        [string]$Name,
        [string]$ScriptText
    )

    [Byte[]]$scriptByteArray = [Text.Encoding]::Unicode.GetPreamble()
    $scriptByteArray += [Text.Encoding]::Unicode.GetBytes($ScriptText)
    $ScriptBody = [Convert]::ToBase64String($scriptByteArray)

    try {
        $Body = @{
            ParamsDefinition = ""
            ScriptName       = $Name
            Author           = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
            Script           = $ScriptBody
            ScriptVersion    = "1"
            ScriptType       = 0 # Powershell
            ParameterlistXML = ""
            ScriptGuid       = (New-GUID).ToString().ToUpper()
        }

        $ExistingScript = Get-CMScript -ScriptName $Name
        if ($ExistingScript) {
            Write-Host "A Script with this name already exists. Try again with a new name." -ForegroundColor Yellow
        }
        else {
            $Result = Invoke-CMPost -URI "$($script:ASWmiURI)/SMS_Scripts.CreateScripts" -Body $Body
            Return $Result | Select-Object -Property * -ExcludeProperty _*, `@odata*
        }
    }
    catch {
        throw $_
    }
}