function Get-PVENodeCpuInfo {

    [CmdletBinding()]
    [Alias('gpvencpu')]
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
                Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/cpu") | Select-Object -ExpandProperty data
            }
            catch {
                Write-Error -Exception $_.Exception
            }

        }

    }

}
