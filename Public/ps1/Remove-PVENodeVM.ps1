function Remove-PVENodeVM {

    [CmdletBinding()]
    [Alias('rpvenvm')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxVM[]]
        $ProxmoxVM,

        [Parameter(Position = 1)]
        [Switch]
        $Purge,

        [Parameter(Position = 2)]
        [Switch]
        $SkipLock
    )
    process {

        $ProxmoxVM | ForEach-Object {

            $vm = $_
            $uri = $ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($vm.node.node)/qemu/$($vm.vmid)"
            if ($Purge.IsPresent -and $SkipLock.IsPresent) { $uri = $uri + "?purge=1&skiplock=1" }
            elseif ($Purge.IsPresent -and -not $SkipLock.IsPresent) { $uri = $uri + "?purge=1" }
            elseif ($SkipLock.IsPresent -and -not $Purge.IsPresent) { $uri = $uri + "?skiplock=1" }
            try {
                Send-PveApiRequest -Method Delete -Uri $uri | Select-Object -ExpandProperty data
            }
            catch {
                Write-Error -Exception $_.Exception
            }

        }

    }

}