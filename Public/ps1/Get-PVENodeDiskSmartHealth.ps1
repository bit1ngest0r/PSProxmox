function Get-PVENodeDiskSmartHealth {

    [CmdletBinding()]
    [Alias('gpvendskhlth')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxNode[]]
        $ProxmoxNode,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $BlockDeviceName,

        [Parameter()]
        [Switch]
        $HealthOnly
    )
    process {

        $ProxmoxNode | ForEach-Object {
            
            $node = $_
            $BlockDeviceName | ForEach-Object {

                $body = @{}
                $body.Add('disk', $_)
                if ($PSBoundParameters['HealthOnly']) { $body.Add('healthonly', 1) }
                try {
                   Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/disks/smart") -Body $body | Select-Object -ExpandProperty data
                }
                catch {
                    Write-Error -Exception $_.Exception
                }

            }

        }

    }

}
