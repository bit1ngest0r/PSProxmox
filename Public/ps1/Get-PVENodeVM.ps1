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
             
            if ($VMID) {

                $VMID | ForEach-Object {
                    
                    try {
                        Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/qemu/$_/status/current") | 
                        Select-Object -ExpandProperty data
                    }
                    catch {
                        $_ | Write-Error
                    }    

                }

            }
            else {
                 
                try {
                    Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/qemu") | Select-Object -ExpandProperty data
                }
                catch {
                    throw $_.Exception
                }

            }

        }

    }

}
