function Get-PVENode {

    [CmdletBinding()]
    [Alias('gpven')]
    Param ()
    process {

        try {

            Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'nodes') | Select-Object -ExpandProperty data |
            ForEach-Object {
                $ProxmoxNode = New-Object ProxmoxNode
                $ProxmoxNode.node = $_.node
                $ProxmoxNode.status = $_.status
                $ProxmoxNode.cpu = $_.cpu
                $ProxmoxNode.level = $_.level
                $ProxmoxNode.maxcpu = $_.maxcpu
                $ProxmoxNode.maxmem = $_.maxmem
                $ProxmoxNode.mem = $_.mem
                $ProxmoxNode.ssl_fingerprint = $_.ssl_fingerprint
                $ProxmoxNode.uptime = $_.uptime
                return $ProxmoxNode
            }
        
        }
        catch {

            throw $_.Exception

        }

    }

}
