function Get-PVENodeJournal {

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [Alias('gpvenjrnl')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Cursor'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Date'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Tail'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ParameterSetName = 'Default'
        )]
        [ProxmoxNode[]]
        $ProxmoxNode,
        
        [Parameter(ParameterSetName = 'Tail')]
        [Int]
        $TailLineCount,

        [Parameter(
            ParameterSetName = 'Cursor',
            HelpMessage = 'Must be in syslog cursor format: s=53df152b0f194b388e401b113f493a67;i=1c8f3;b=7f8c9489c6794eaabd58a7dee34e8371;m=ed3c4c2996;t=5ae840bd1e43e;x=bc2ede37256647c9'
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $StartAtCursor,

        [Parameter(
            ParameterSetName = 'Cursor',
            HelpMessage = 'Must be in syslog cursor format: s=53df152b0f194b388e401b113f493a67;i=1c8f3;b=7f8c9489c6794eaabd58a7dee34e8371;m=ed3c4c2996;t=5ae840bd1e43e;x=bc2ede37256647c9'
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $EndAtCursor,

        [Parameter(ParameterSetName = 'Date')]
        [DateTime]
        $StartDate,

        [Parameter(ParameterSetName = 'Date')]
        [DateTime]
        $EndDate
    )
    begin { 

        $body = @{}
        if ($PSBoundParameters['TailLineCount']) { $body.Add('lastentries', $PSBoundParameters['TailLineCount']) }
        if ($PSBoundParameters['StartDate']) { $body.Add('since', $PSBoundParameters['StartDate'].ToString('yyyy-MM-dd hh:mm:ss')) }
        if ($PSBoundParameters['EndDate']) { $body.Add('until', $PSBoundParameters['EndDate'].ToString('yyyy-MM-dd hh:mm:ss')) }
        if ($PSBoundParameters['StartAtCursor']) { $body.Add('startcursor', $PSBoundParameters['StartAtCursor']) }
        if ($PSBoundParameters['EndAtCursor']) { $body.Add('endcursor', $PSBoundParameters['EndAtCursor']) }

    }
    process {

        $ProxmoxNode | ForEach-Object {
            
            try {
                Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($_.node)/journal") -Body $body | Select-Object -ExpandProperty data
            }
            catch {
                Write-Error -Exception $_.Exception
            }

        }

    }

}
