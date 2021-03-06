function Get-PVENodeService {

    [CmdletBinding()]
    [Alias('gpvenreport')]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ProxmoxNode[]]
        $ProxmoxNode,

        [Parameter()]
        [ValidateSet('corosync', 'cron', 'ksmtuned', 'postfix', 'pve-cluster', 'pvedaemon', 'pve-firewall', 'pvefw-logger', 'pve-ha-crm', 'pve-ha-lrm', 'pveproxy', 'pvestatd', 'spiceproxy', 'sshd', 'syslog', 'systemd-timesyncd')]
        [String[]]
        $ServiceName
    )
    process {

        $ProxmoxNode | ForEach-Object {
            
            $node = $_
            if ($ServiceName) {

                $ServiceName | ForEach-Object {

                    try {
                        Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/services/" + $_) | 
                        Select-Object -ExpandProperty data
                    }
                    catch {
                        Write-Error -Exception $_.Exception
                    }

                }

            }
            else {

                try {
                    Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + "nodes/$($node.node)/services") | Select-Object -ExpandProperty data
                }
                catch {
                    Write-Error -Exception $_.Exception
                }

            }

        }

    }

}
