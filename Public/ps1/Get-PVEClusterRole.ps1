function Get-PVEClusterRole {

    [CmdletBinding()]
    [Alias('gpvecrole')]
    Param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $RoleId
    )
    process {

        if ($RoleId) {
            
            $RoleId | ForEach-Object {

                try {
                    Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'access/roles/' + $_) | Select-Object -ExpandProperty data
                }
                catch {
                    Write-Error -Exception $_.Exception
                }

            }

        }
        else {

            try {
                Send-PveApiRequest -Method Get -Uri ($ProxmoxApiBaseUri.AbsoluteUri + 'access/roles') | Select-Object -ExpandProperty data
            }
            catch {
                throw $_.Exception
            }

        }

    }

}
