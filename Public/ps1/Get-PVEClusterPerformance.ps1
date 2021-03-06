function Get-PVEClusterPerformance {

    [CmdletBinding()]
    [Alias('gpvecperf')]
    Param (
        [Parameter()]
        [ValidateSet('node', 'sdn', 'storage', 'vm')]
        [String]
        $Type
    )
    begin {

        $body = @{}
        if ($PSBoundParameters['Type']) { $body.Add('type', $PSBoundParameters['Type']) }

    }
    process {
        
        try {
            Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'cluster/resources') -Body $body | Select-Object -ExpandProperty data    
        }
        catch {
            throw $_.Exception
        }

    }

}
