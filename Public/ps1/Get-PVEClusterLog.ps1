function Get-PVEClusterLog {

    [CmdletBinding()]
    [Alias('gpveclog')]
    Param ()
    process {

        try {
            Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'cluster/log') | Select-Object -ExpandProperty data
        }
        catch {
            throw $_.Exception
        }

    }

}
