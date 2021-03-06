function Get-PVENodeTime {

    [CmdletBinding()]
    [Alias('gpventime')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxNode[]]
        $ProxmoxNode
    )
    begin { 
        
        [DateTime]$epoch = '1970-01-01 00:00:00'

    }
    process {

        $ProxmoxNode | ForEach-Object {

            try {
                $data = Send-PveApiRequest -Method Get -Uri ($proxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/time") | Select-Object -ExpandProperty data
                $data.time = $epoch.AddSeconds($data.time)
                $data.localtime = $epoch.AddSeconds($data.localtime)
                return $data    
            }
            catch {
                Write-Error -Exception $_.Exception
            }

        }

    }

}
