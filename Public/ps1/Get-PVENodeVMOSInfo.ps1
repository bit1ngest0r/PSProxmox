function Get-PVENodeVMOSInfo {

    [CmdletBinding()]
    [Alias('gpvenvmos')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxVM[]]
        $ProxmoxVM
    )
    process {
    
        $ProxmoxVM | ForEach-Object {
            
            $vm = $_
            try {
                Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($vm.node.node)/qemu/$($vm.vmid)/agent/get-osinfo/") | 
                Select-Object -ExpandProperty data | Select-Object -ExpandProperty result
            }
            catch {

                if ($_.Exception.Response.StatusDescription -eq 'QEMU guest agent is not running') {
                    throw 'QEMU guest agent is not running'
                }
                else {
                    Write-Error -Exception $_.Exception
                }

            }

        }

    }

}
