function Get-PVEClusterGroup {

    [CmdletBinding()]
    [Alias('gpvecgroup')]
    Param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $GroupId
    )
    process {

        if ($GroupId) {
            
            $GroupId | ForEach-Object {

                try {
                    Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'access/groups/' + $_) | Select-Object -ExpandProperty data
                }
                catch {
                    Write-Error -Exception $_.Exception
                }

            }

        }
        else {

            try {
                Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'access/groups') | Select-Object -ExpandProperty data
            }
            catch {
                throw $_.Exception
            }

        }

    }

}
