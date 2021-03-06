function Get-PVENodeContainer {

    [CmdletBinding()]
    [Alias('gpvenlxc')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxNode[]]
        $ProxmoxNode,

        [Parameter(Position = 1)]
        [Int[]]
        $ContainerId
    )
    process {

        $ProxmoxNode | ForEach-Object {
             
            $node = $_
            if ($ContainerId) {

                $ContainerId | ForEach-Object {
                    
                    try {
                        $request = Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/lxc/$_/status/current") | 
                        Select-Object -ExpandProperty data
                        $ProxmoxContainer = New-Object ProxmoxContainer
                        $ProxmoxContainer.node = $node
                        $ProxmoxContainer.cpu = $request.cpu
                        $ProxmoxContainer.cpus = $request.cpus
                        $ProxmoxContainer.disk = $request.disk
                        $ProxmoxContainer.diskread = $request.diskread
                        $ProxmoxContainer.diskwrite = $request.diskwrite
                        $ProxmoxContainer.lock = $request.lock
                        $ProxmoxContainer.maxdisk = $request.maxdisk
                        $ProxmoxContainer.maxmem = $request.maxmem
                        $ProxmoxContainer.maxswap = $request.maxswap
                        $ProxmoxContainer.mem = $request.mem
                        $ProxmoxContainer.name = $request.name
                        $ProxmoxContainer.netin = $request.netin
                        $ProxmoxContainer.netout = $request.netout
                        $ProxmoxContainer.status = $request.status
                        $ProxmoxContainer.swap = $request.swap
                        $ProxmoxContainer.template = $request.template
                        $ProxmoxContainer.type = $request.type
                        $ProxmoxContainer.uptime = $request.uptime
                        $ProxmoxContainer.vmid = $request.vmid
                        return $ProxmoxContainer
                    }
                    catch {
                        Write-Error -Exception $_.Exception
                    }    

                }

            }
            else {
                 
                try {
                    Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/lxc") | Select-Object -ExpandProperty data |
                    ForEach-Object {
                        $ProxmoxContainer = New-Object ProxmoxContainer
                        $ProxmoxContainer.node = $node
                        $ProxmoxContainer.cpu = $_.cpu
                        $ProxmoxContainer.cpus = $_.cpus
                        $ProxmoxContainer.disk = $_.disk
                        $ProxmoxContainer.diskread = $_.diskread
                        $ProxmoxContainer.diskwrite = $_.diskwrite
                        $ProxmoxContainer.lock = $_.lock
                        $ProxmoxContainer.maxdisk = $_.maxdisk
                        $ProxmoxContainer.maxmem = $_.maxmem
                        $ProxmoxContainer.maxswap = $_.maxswap
                        $ProxmoxContainer.mem = $_.mem
                        $ProxmoxContainer.name = $_.name
                        $ProxmoxContainer.netin = $_.netin
                        $ProxmoxContainer.netout = $_.netout
                        $ProxmoxContainer.status = $_.status
                        $ProxmoxContainer.swap = $_.swap
                        $ProxmoxContainer.template = $_.template
                        $ProxmoxContainer.type = $_.type
                        $ProxmoxContainer.uptime = $_.uptime
                        $ProxmoxContainer.vmid = $_.vmid
                        return $ProxmoxContainer
                    }
                }
                catch {
                    throw $_.Exception
                }

            }

        }

    }

}
