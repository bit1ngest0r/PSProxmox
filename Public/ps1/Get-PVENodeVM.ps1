function Get-PVENodeVM {

    [CmdletBinding()]
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
                        Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/qemu/$_/status/current") | 
                        Select-Object -ExpandProperty data
                    }
                    catch {
                        Write-Error -Exception $_.Exception
                    }    

                }

            }
            else {
                 
                try {
                    Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/qemu") | Select-Object -ExpandProperty data
                }
                catch {
                    throw $_.Exception
                }

            }

        }

    }

}
