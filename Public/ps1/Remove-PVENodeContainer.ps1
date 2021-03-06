function Remove-PVENodeContainer {

    [CmdletBinding()]
    [Alias('rpvenlxc')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxContainer[]]
        $ProxmoxContainer,

        [Parameter(Position = 1)]
        [Switch]
        $Purge,

        [Parameter(Position = 2)]
        [Switch]
        $Force
    )
    process {

        $ProxmoxContainer | ForEach-Object {

            $lxc = $_
            $uri = $ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($lxc.node.node)/lxc/$($lxc.vmid)"
            if ($Purge.IsPresent -and $Force.IsPresent) { $uri = $uri + "?purge=1&force=1" }
            elseif ($Purge.IsPresent -and -not $Force.IsPresent) { $uri = $uri + "?force=1" }
            elseif ($Force.IsPresent -and -not $Purge.IsPresent) { $uri = $uri + "?force=1" }
            try {
                Send-PveApiRequest -Method Delete -Uri $uri -Body $body | Select-Object -ExpandProperty data
            }
            catch {
                Write-Error -Exception $_.Exception
            }

        }

    }

}
