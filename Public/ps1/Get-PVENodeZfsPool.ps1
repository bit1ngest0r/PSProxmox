function Get-PVENodeZFSPool {

    [CmdletBinding()]
    [Alias('gpvenzfs')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxNode[]]
        $ProxmoxNode,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $PoolName
    )
    process {

        $ProxmoxNode | ForEach-Object {
            
            $node = $_
            if ($PoolName) {

                $PoolName | ForEach-Object {

                    try {
                        Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/disks/zfs/$_") | 
                        Select-Object -ExpandProperty data
                    }
                    catch {
                        Write-Error -Exception $_.Exception
                    }    

                }

            }
            else {

                try {
                    Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/disks/zfs") | Select-Object -ExpandProperty data
                }
                catch {
                    Write-Error -Exception $_.Exception
                }

            }

        }

    }
    
}
