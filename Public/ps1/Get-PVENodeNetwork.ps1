
function Get-PVENodeNetwork {

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [Alias('gpvennetwork')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Type'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Interface'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Default'
        )]
        [ProxmoxNode[]]
        $ProxmoxNode,

        [Parameter(ParameterSetName = 'Type')]
        [ValidateSet('alias', 'any_bridge', 'bond', 'bridge', 'eth', 'OVSBond', 'OVSBridge', 'OVSIntPort', 'OVSPort', 'vlan')]
        [String]
        $Type,

        [Parameter(ParameterSetName = 'Interface')]
        [ValidateNotNullOrEmpty()]
        [String]
        $InterfaceName
    )
    begin { 

        $body = @{}
        if ($PSBoundParameters['Type']) { $body.Add('type', $PSBoundParameters['Type']) }

    }
    process {

        $ProxmoxNode | ForEach-Object {
            
            $node = $_
            if ($InterfaceName) {

                $InterfaceName | ForEach-Object {
                    
                    try {
                        Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/network/" + $_) -Body $body | 
                        Select-Object -ExpandProperty data
                    }
                    catch {
                        Write-Error -Exception $_.Exception
                    }

                }

            }
            else {

                try {
                    Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/network") | Select-Object -ExpandProperty data
                }
                catch {
                    Write-Error -Exception $_.Exception
                }

            }

        }   

    }

}
