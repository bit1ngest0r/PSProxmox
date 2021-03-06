function Get-PVENodeAptPackage {

    [CmdletBinding(DefaultParameterSetName = 'Versions')]
    [Alias('gpvenaptpkg')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Changelog'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Update'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Versions'
        )]
        [ProxmoxNode[]]
        $ProxmoxNode,

        [Parameter(ParameterSetName = 'Changelog')]
        [Switch]
        $ChangeLog,

        [Parameter(
            ParameterSetName = 'Changelog',
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $PackageName,

        [Parameter(ParameterSetName = 'Changelog')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Version,

        [Parameter(ParameterSetName = 'Update')]
        [Switch]
        $ListUpdates,

        [Parameter(ParameterSetName = 'Versions')]
        [Switch]
        $ListVersions
    )
    process {

        $ProxmoxNode | ForEach-Object {
            
            $body = @{}
            if ($PSCmdlet.ParameterSetName -eq 'Changelog') {
                $body.Add('name', $PSBoundParameters['PackageName'])
                if ($PSBoundParameters['Version']) { $body.Add('version', $PSBoundParameters['Version']) }
                $uri = $ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/apt/changelog"
            }
            elseif ($PSCmdlet.ParameterSetName -eq 'Update') {
                $uri = $ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/apt/update"
            }
            else {
                $uri = $ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/apt/versions"
            }

            try {
                Send-PveApiRequest -Method Get -Uri $uri -Body $body | Select-Object -ExpandProperty data
            }
            catch {
                Write-Error -Exception $_.Exception
            }

        }

    }

}
