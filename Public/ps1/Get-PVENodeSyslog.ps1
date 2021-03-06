function Get-PVENodeSyslog {

    [CmdletBinding()]
    [Alias('gpvensyslog')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxNode[]]
        $ProxmoxNode,

        [Parameter()]
        [Int]
        $ResultCount,

        [Parameter()]
        [Int]
        $StartAtLogLine,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $ServiceID,

        [Parameter()]
        [DateTime]
        $StartDate,

        [Parameter()]
        [DateTime]
        $EndDate
    )
    begin { 
 
        $body = @{}
        if ($PSBoundParameters['ResultCount']) { $body.Add('limit', $PSBoundParameters['ResultCount']) }
        if ($PSBoundParameters['StartAtLogLine']) { $body.Add('start', $PSBoundParameters['StartAtLogLine']) }
        if ($PSBoundParameters['ServiceID']) { $body.Add('service', $PSBoundParameters['ServiceID']) }
        if ($PSBoundParameters['StartDate']) { $body.Add('since', $PSBoundParameters['StartDate'].ToString('yyyy-MM-dd hh:mm:ss')) }
        if ($PSBoundParameters['EndDate']) { $body.Add('until', $PSBoundParameters['EndDate'].ToString('yyyy-MM-dd hh:mm:ss')) }

    }
    process {

        $ProxmoxNode | ForEach-Object {

            try {
                Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/syslog") -Body $body | 
                Select-Object -ExpandProperty data   
            }
            catch {
                Write-Error -Exception $_.Exception
            }

        }

    }

}
