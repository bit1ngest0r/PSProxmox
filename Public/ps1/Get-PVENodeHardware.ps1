function Get-PVENodeHardware {

    [CmdletBinding()]
    [Alias('gpvenhw')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxNode[]]
        $ProxmoxNode,

        [Parameter()]
        [ValidateSet('pci')]
        [String]
        $Type = 'pci'
    )
    process {

        $ProxmoxNode | ForEach-Object {
            
            try {
                Send-PveApiRequest -Method Get -Uri ($proxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/hardware/$Type") | Select-Object -ExpandProperty data
            }
            catch {
                Write-Error -Exception $_.Exception
            }

        }

    }

}
