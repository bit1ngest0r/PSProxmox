function Get-PVENodeNetStat {

    [CmdletBinding()]
    [Alias('gpvennetstat')]
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
                Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/netstat") | Select-Object -ExpandProperty data
            }
            catch {
                Write-Error -Exception $_.Exception
            }

        }

    }

}
