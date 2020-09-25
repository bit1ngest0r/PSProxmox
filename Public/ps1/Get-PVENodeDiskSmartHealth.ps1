function Get-PVENodeDiskSmartHealth {

    [CmdletBinding()]
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
            
            $BlockDeviceName | ForEach-Object {

                $body = @{}
                $body.Add('disk', $_)
                if ($PSBoundParameters['HealthOnly']) { $body.Add('healthonly', $true) }
                try {
                   Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/disks/smart") -Body $body | Select-Object -ExpandProperty data
                }
                catch {
                    $_ | Write-Error
                }

            }

        }

    }

}
