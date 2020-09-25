function Get-PVEClusterRole {

    [CmdletBinding()]
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
                    $_ | Write-Error
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
