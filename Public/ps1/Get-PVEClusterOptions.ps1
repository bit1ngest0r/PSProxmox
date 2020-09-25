function Get-PVEClusterOptions {

    [CmdletBinding()]
    Param ()
    process {

        try {
            Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'cluster/options') | Select-Object -ExpandProperty data
        }
        catch {
            throw $_.Exception
        }

    }

}
