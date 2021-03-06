function Get-PVENodeVM {

    [CmdletBinding()]
    [Alias('gpvenvm')]
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
        $VMID
    )
    process {

        $ProxmoxNode | ForEach-Object {
             
            $node = $_
            if ($VMID) {

                $VMID | ForEach-Object {
                    
                    try {
                        $request = Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/qemu/$_/status/current") | 
                        Select-Object -ExpandProperty data
                        $ProxmoxVM = New-Object ProxmoxVM
                        $ProxmoxVM.node = $node
                        $ProxmoxVM.cpu = $request.cpu
                        $ProxmoxVM.cpus = $request.cpus
                        $ProxmoxVM.disk = $request.disk
                        $ProxmoxVM.diskread = $request.diskread
                        $ProxmoxVM.diskwrite = $request.diskwrite
                        $ProxmoxVM.maxdisk = $request.maxdisk
                        $ProxmoxVM.maxmem = $request.maxmem
                        $ProxmoxVM.mem = $request.mem
                        $ProxmoxVM.name = $request.name
                        $ProxmoxVM.netin = $request.netin
                        $ProxmoxVM.netout = $request.netout
                        $ProxmoxVM.pid = $request.pid
                        $ProxmoxVM.status = $request.status
                        $ProxmoxVM.template = $request.template
                        $ProxmoxVM.uptime = $request.uptime
                        $ProxmoxVM.vmid = $request.vmid
                        return $ProxmoxVM                    
                    }
                    catch {
                        Write-Error -Exception $_.Exception
                    }    

                }

            }
            else {
                 
                try {
                    Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/qemu") | Select-Object -ExpandProperty data | 
                    ForEach-Object {
                        $ProxmoxVM = New-Object ProxmoxVM
                        $ProxmoxVM.node = $node
                        $ProxmoxVM.cpu = $_.cpu
                        $ProxmoxVM.cpus = $_.cpus
                        $ProxmoxVM.disk = $_.disk
                        $ProxmoxVM.diskwrite = $_.diskwrite
                        $ProxmoxVM.maxdisk = $_.maxdisk
                        $ProxmoxVM.maxmem = $_.maxmem
                        $ProxmoxVM.mem = $_.mem
                        $ProxmoxVM.name = $_.name
                        $ProxmoxVM.netin = $_.netin
                        $ProxmoxVM.netout = $_.netout
                        $ProxmoxVM.pid = $_.pid
                        $ProxmoxVM.status = $_.status
                        $ProxmoxVM.template = $_.template
                        $ProxmoxVM.uptime = $_.uptime
                        $ProxmoxVM.vmid = $_.vmid
                        return $ProxmoxVM
                    }
                }
                catch {
                    throw $_.Exception
                }

            }

        }

    }

}
