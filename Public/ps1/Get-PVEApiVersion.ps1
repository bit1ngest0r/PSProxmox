function Get-PVEApiVersion {

    [CmdletBinding()]
    Param ()
    process {

        try {
            Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'version') | Select-Object -ExpandProperty data
        }
        catch {
            throw $_.Exception
        }

    }

}
