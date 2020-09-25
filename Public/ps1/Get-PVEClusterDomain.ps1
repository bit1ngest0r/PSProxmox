function Get-PVEClusterDomain {

    [CmdletBinding()]
    Param ()
process {

        try {
            Send-PveApiRequeset -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'access/domains') | Select-Object -ExpandProperty data           
        }
        catch {
            throw $_.Exception
        }

    }

}
