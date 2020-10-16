function Get-PVECluster {

    [CmdletBinding()]
    [Alias('gpveclstr')]
    Param ()
    process {
        
        try {
            Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'cluster/status') | Select-Object -ExpandProperty data
        }
        catch {
            throw $_.Exception
        }

    }

}
