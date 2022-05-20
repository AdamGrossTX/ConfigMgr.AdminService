function Invoke-WaitScriptResult {
    [cmdletbinding()]
    param (
        [int]$ResourceId,
        [int]$OperationId,
        [int]$SecondsToWait = 60,
        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )
    PROCESS {
        try {
            if ($InputObject) {
                $OperationId = $InputObject.OperationId
                $ResourceId = $InputObject.ResourceId
            }
            $startTime = Get-Date
            $status = 0
            while ($status -eq 0) {
                try {
                    $scriptResult = Get-CMScriptResult -ResourceId $ResourceId -OperationId $OperationId
                    $status = $scriptResult.Status
                    $ResultObj = [PSCustomObject]@{
                        Status            = $scriptResult.Status
                        ScriptOutput      = $scriptResult.Result.ScriptOutput.Replace("]", "").Replace("[", "")
                        SecondsToComplete = ((Get-Date) - $startTime).TotalSeconds
                    }
                }
                catch [System.Net.WebException] {
                    $HttpResultCode = $_.Exception.Response.StatusCode.value__
                    if ($HttpResultCode -eq 404) {
                        $status = 0 # still waiting for result
                        Write-Verbose "Waiting for the device to report script result..."
                        Start-sleep 1
                    }
                    else {
                        throw $_
                    }
                }
                # Need to time out eventually, wait 1 minute
                $currentTime = Get-Date
                if (($currentTime - $startTime).TotalSeconds -ge $SecondsToWait) {
                    $ResultObj = [PSCustomObject]@{
                        Status            = 2
                        ScriptOutput      = "Timed out waiting for script result"
                        SecondsToComplete = ((Get-Date) - $startTime).TotalSeconds
                    }
                    $status = 2
                }
            }
            return $ResultObj
        }
        catch {
            throw $_
        }
    }
}