function Get-FilterString {
    [cmdletbinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        $FilterObjs
    )

    Add-Type -AssemblyName System.Web -ErrorAction SilentlyContinue

    $Filter = "?`$filter=" +
    [System.Web.HTTPUtility]::UrlEncode((($FilterObjs | ForEach-Object {
            $value = if ($_.value -is [string]) {
                "'$($_.Value)'"
            }
            else {
                $_.Value
            }
            "{0} {1} {2}" -f $_.Property, $_.Operator, $value
        } | Where-Object { $_ -ne '' }) -join 'and'))

    $Filter = $Filter.trim()

    if ($Filter -ne "?`$filter=++") {
        return $Filter
    }
    else {
        return $null
    }
}