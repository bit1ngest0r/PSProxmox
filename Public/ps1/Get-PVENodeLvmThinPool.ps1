function Get-PVENodeLvmThinPool {

    [CmdletBinding()]
    [Alias('gpventhinpool')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxNode[]]
        $ProxmoxNode
    )
    process {

        $ProxmoxNode | ForEach-Object {

            try {
                Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/disks/lvmthin") | 
                Select-Object -ExpandProperty data   
            }
            catch {
                Write-Error -Exception $_.Exception
            }

        }

    }

}
