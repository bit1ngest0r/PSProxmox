function Get-PVEClusterLog {

    [CmdletBinding()]
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
