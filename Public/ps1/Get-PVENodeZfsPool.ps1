function Get-PVENodeZfsPool {

    [CmdletBinding()]
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
            
            if ($PoolName) {

                $PoolName | ForEach-Object {

                    try {
                        Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/disks/zfs/$_") | 
                        Select-Object -ExpandProperty data
                    }
                    catch {
                        $_ | Write-Error
                    }    

                }

            }
            else {

                try {
                    Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/disks/zfs") | Select-Object -ExpandProperty data
                }
                catch {
                    $_ | Write-Error
                }

            }

        }

    }
    
}
